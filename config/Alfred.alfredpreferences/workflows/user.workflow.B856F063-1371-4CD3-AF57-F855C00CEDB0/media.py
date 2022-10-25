# encoding: utf-8
from __future__ import unicode_literals, print_function

import os
import sys
import argparse
import urllib
import urllib.parse
import urllib.request
import re
import json
from mako.template import Template

ICON_ROOT = '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources'
ICON_USER = os.path.join(ICON_ROOT, 'UserIcon.icns')
ICON_GROUP = os.path.join(ICON_ROOT, 'GroupIcon.icns')

DEFAULT_TMDB_API_KEY = '0ebad901a16d3bf7f947b0a8d1808c44'
TMDB_API_URL = 'https://api.themoviedb.org/3/'
OMDB_API_URL = 'https://www.omdbapi.com/'
IMDB_URL = 'https://imdb.com/'
YOUTUBE_WATCH_URL = 'https://youtube.com/watch?v='
METACRITIC_SEARCH_URL = 'https://metacritic.com/search/'
ROTTEN_TOMATOES_SEARCH_URL = 'https://rottentomatoes.com/search/?search='
LETTERBOXD_URL = 'https://letterboxd.com/imdb/'
CACHEDIR = os.path.expanduser(
    '~/Library/Caches/com.runningwithcrayons.Alfred/Workflow Data/com.mcknight.movies')
HTML_SUMMARY_FILE = os.path.join(CACHEDIR, "item.html")

if not os.path.exists(CACHEDIR):
    os.makedirs(CACHEDIR)

items = []


def main(media_type, query):

    global METACRITIC_SEARCH_URL
    METACRITIC_SEARCH_URL += media_type + '/'

    api_key = DEFAULT_TMDB_API_KEY

    m = re.match('([m|t])\:([0-9]*)', query)
    if query[:2] == 'm:' or query[:2] == 't:' and m.group(2):
        try:
            item = get_tmdb_info(m.group(1), m.group(2), api_key)
            log('TMDb info retrieved.')
            if m.group(1) == 'm' or m.group(1) == 't':
                show_item_info(item, media_type)
        except AttributeError as e:
            log(e)
            items.append({
                "title": "The item was not found"
            })
    else:
        def wrapper():
            return get_tmdb_configuration(api_key)

        try:
            url = f'{TMDB_API_URL}search/{media_type}'
            params = {"api_key": api_key,
                      "query": query, "search_type": 'ngram'}
            results = get_json(url, params)
        except Exception as e:
            log(e)
            items.append({
                "title": "Uh oh... something went wrong",
                "subtitle": "Please check your internet connection."
            })
            output_items()
            return 0

        if 'status_code' in results:
            items.append({"title": "Nothing was found."})
        elif 'results' in results:
            if not results['results']:
                items.append({"title": "Nothing was found."})
            results['results'].sort(key=extract_popularity, reverse=True)
            for item in results['results']:
                if media_type == 'movie':
                    title = item['title']
                    if item.get('release_date', 0):
                        title += ' (' + item['release_date'][:4] + ')'
                else:
                    title = item['name']
                    if item.get('first_air_date', 0):
                        title += ' (' + item['first_air_date'][:4] + ')'
                items.append({
                    "title": title,
                    "arg": str(item['id']),
                    "valid": False,
                    "autocomplete": media_type[:1] + ':' + str(item['id'])
                })
    output_items()


def get_tmdb_configuration(api_key):
    url = TMDB_API_URL + 'configuration'
    params = dict(api_key=api_key)
    return get_json(url, params)


def get_tmdb_info(item_type, item_id, api_key):
    url = TMDB_API_URL
    if item_type == 'm':
        url += 'movie/' + item_id
    elif item_type == 't':
        url += 'tv/' + item_id
    params = dict(
        api_key=api_key, language='en', append_to_response='videos,external_ids,watch/providers')

    return get_json(url, params)


def get_omdb_info(imdb_id):
    url = OMDB_API_URL
    params = dict(i=imdb_id, tomatoes=True, apikey=os.environ['omdb_api_key'])
    return get_json(url, params)


def show_item_info(item, media_type):
    title_key = 'title'
    release_date_key = 'release_date'
    if media_type == 'movie':
        imdb_id = item['imdb_id']
    elif media_type == 'tv':
        imdb_id = item['external_ids']['imdb_id']
        title_key = 'name'
        release_date_key = 'first_air_date'
    omdb_info = get_omdb_info(imdb_id)
    log('OMDb info retrieved.')

    if omdb_info['Response'] == 'False':
        items.append({"title": "Details not found."})
        return

    title = item[title_key]
    if item[release_date_key]:
        title += ' (' + item[release_date_key][:4] + ')'

    items.append({"title": title,
                  "subtitle": get_subtitle(omdb_info),
                  "valid": True,
                  # icon : "poster.jpg",
                  "quicklookurl": "file://" + urllib.request.pathname2url(HTML_SUMMARY_FILE)})

    search = urllib.parse.quote(item[title_key].encode(
        'utf-8'), safe=':'.encode('utf-8'))

    all_search_sites = []

    # IMDb
    search_url = IMDB_URL + 'title/' + omdb_info['imdbID']
    all_search_sites.append(search_url)
    if omdb_info['imdbRating'] != 'N/A':
        items.append({"title": omdb_info['imdbRating'],
                      "subtitle": 'IMDb (' + omdb_info['imdbVotes'] + " votes)",
                      "icon": {"path": 'img/imdb.png'},
                      "valid": True,
                      "arg": search_url,
                      "text": {
                          "copy": omdb_info['imdbID']}
                      })
    else:
        items.append({"title": 'IMDb',
                      "subtitle": f"Search IMDb for '{item[title_key]}'",
                      "icon": {"path": 'img/imdb.png'},
                      "valid": True,
                      "arg": search_url})

    # Rotten Tomatoes
    search_url = ROTTEN_TOMATOES_SEARCH_URL + search
    if omdb_info['tomatoURL']:
        search_url = omdb_info['tomatoURL']
    all_search_sites.append(search_url)
    if omdb_info['tomatoMeter'] != 'N/A':
        tomatoIcon = 'img/fresh.png'
        if omdb_info['tomatoImage'] == 'N/A':
            tomatoIcon = 'img/noidea.png'
        else:
            tomatoIcon = 'img/' + omdb_info['tomatoImage'] + '.png'

        items.append({"title": omdb_info['tomatoMeter'] + '%',
                      "subtitle": 'Rotten Tomatoes (' + omdb_info['tomatoReviews'] + ' reviews, ' +
                      omdb_info['tomatoFresh'] + ' fresh, ' +
                      omdb_info['tomatoRotten'] + ' rotten)',
                      "icon": {"path": tomatoIcon},
                      "valid": True,
                      "arg": search_url})
    else:
        for rating in omdb_info['Ratings']:
            if rating['Source'] == 'Rotten Tomatoes':
                items.append({"title": rating['Value'],
                              "subtitle": 'Rotten Tomatoes',
                              "icon": {"path": 'img/fresh.png'},
                              "valid": True,
                              "arg": search_url})

    if omdb_info['tomatoUserMeter'] != 'N/A':
        tomatoUserIcon = 'img/rtliked.png'
        if int(omdb_info['tomatoUserMeter']) < 60:
            tomatoUserIcon = 'img/rtdisliked.png'

        items.append({"title": omdb_info['tomatoUserMeter'] + '%',
                      "subtitle": 'Rotten Tomatoes Audience Score (' + omdb_info['tomatoUserReviews'] +
                      ' reviews, ' +
                      omdb_info['tomatoUserRating'] + ' avg rating)',
                      "icon": {"path": tomatoUserIcon},
                      "valid": True,
                      "arg": search_url})

    # Metacritic
    search_url = METACRITIC_SEARCH_URL + search + '/results'
    all_search_sites.append(search_url)
    if omdb_info['Metascore'] != 'N/A':
        items.append({"title": omdb_info['Metascore'],
                      "subtitle": 'Metacritic',
                      "icon": {"path": 'img/meta.png'},
                      "valid": True,
                      "arg": search_url})
    else:
        items.append({"title": 'Metacritic',
                      "subtitle": f"Search Metacritic for '{item[title_key]}'",
                      "icon": {"path": 'img/meta.png'},
                      "valid": True,
                      "arg": search_url})

    # Letterboxd
    search_url = LETTERBOXD_URL + omdb_info['imdbID']
    all_search_sites.append(search_url)
    items.append({"title": 'Letterboxd',
                  "subtitle": f"View '{item[title_key]}' on Letterboxd",
                  "icon": {"path": 'img/letterboxd.png'},
                  "valid": True,
                  "arg": search_url})

    # JustWatch
    locale = os.environ['locale']
    if locale in item['watch/providers']['results'].keys():
        watchproviders = item['watch/providers']['results'][locale]
        search_url = watchproviders['link']
        justwatchstring = ''
        if 'flatrate' in watchproviders.keys():
            justwatchstring += 'Stream: ' + \
                watchproviders['flatrate'][0]['provider_name'] + ' | '
        if 'buy' in watchproviders.keys():
            justwatchstring += 'Buy: ' + \
                watchproviders['buy'][0]['provider_name'] + ' | '
        if 'rent' in watchproviders.keys():
            justwatchstring += 'Rent: ' + \
                watchproviders['rent'][0]['provider_name'] + ' | '
        justwatchstring = justwatchstring[:-3]  # remove first and last pipe

        all_search_sites.append(search_url)
        items.append({"title": 'JustWatch',
                      "subtitle": justwatchstring,
                      "icon": {"path": 'img/justwatch.png'},
                      "valid": True,
                      "arg": search_url})

    if item['videos']['results']:
        trailer = None
        for video in item['videos']['results']:
            if video['type'] == 'Trailer':
                trailer = video
                break
        if trailer:
            items.append({"title": 'Watch Trailer',
                          "subtitle": trailer['site'] + ' \u2022 ' + str(trailer['size']) + 'p',
                          "valid": True,
                          "arg": YOUTUBE_WATCH_URL + trailer['key'],
                          "icon": {"path": 'img/youtube.png'}})

            all_search_sites.append(YOUTUBE_WATCH_URL + trailer['key'])

    items.append({"title": 'Search',
                  "subtitle": f"Search for '{item[title_key]}' on all rating sites.",
                  "icon": {"path": 'img/ratingsites.png'},
                  "valid": True,
                  "arg": '||'.join(all_search_sites)})

    items.append({"title": omdb_info['Director'],
                  "subtitle": 'Director',
                  "icon": {"path": ICON_USER}})

    items.append({"title": omdb_info['Writer'],
                  "subtitle": 'Writer',
                  "icon": {"path": ICON_USER}})

    items.append({"title": omdb_info['Actors'],
                  "subtitle": 'Actors',
                  "icon": {"path": ICON_GROUP}})

    generate_item_html(omdb_info, item)

    return


def generate_item_html(omdb_info, tmdb_info):
    item_template = Template(
        filename='templates/media.html', output_encoding='utf-8')

    production_company = 'N/A'
    if tmdb_info['production_companies']:
        production_company = tmdb_info['production_companies'][0]['name']

    html = item_template.render(
        title=omdb_info['Title'],
        backdrop_path=tmdb_info['backdrop_path'],
        poster=tmdb_info['poster_path'],
        production_company=production_company,
        overview=tmdb_info['overview'],
        release_date=omdb_info['Released'],
        director=omdb_info['Director'],
        actors=omdb_info['Actors'],
        genre=get_subtitle(omdb_info)
    )
    with open(HTML_SUMMARY_FILE, "wb") as text_file:
        text_file.write(html)

    return


def get_subtitle(omdb_info):
    subtitleItems = []
    if omdb_info['Runtime'] != 'N/A':
        subtitleItems.append(omdb_info['Runtime'])
    if omdb_info['Genre'] != 'N/A':
        subtitleItems.append(omdb_info['Genre'])
    if omdb_info['Rated'] != 'N/A':
        rating_string = omdb_info['Rated']
        if "rated" not in rating_string.lower():
            rating_string = 'Rated ' + rating_string
        subtitleItems.append(rating_string)
    return ' \u2022 '.join(subtitleItems)


def extract_popularity(result):
    if not result['popularity']:
        return 0
    return result['popularity']


def output_items():
    output = {"items": items}
    output_str = json.dumps(output)
    sys.stdout.write(output_str)
    sys.stdout.flush()


def log(s, *args):
    if args:
        s = s % args
    print(s, file=sys.stderr)


def get_json(url, params):
    qstr = urllib.parse.urlencode(params)
    url = f"{url}?{qstr}"
    log(url)
    with urllib.request.urlopen(url) as url_return:
        data = json.load(url_return)
        return data


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description='Get some info on media. This is called from an AlfredApp workflow.')
    parser.add_argument("-t", type=str, default="movie",
                        help="Media type ('movie' or 'tv')")
    parser.add_argument("-q", type=str, default=None, help="Query")

    args = parser.parse_args()
    sys.exit(main(args.t, args.q))
