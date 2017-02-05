(function(e, a) { for(var i in a) e[i] = a[i]; }(exports, /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.reduceUI = reduceUI;
	exports.mapHyperState = mapHyperState;
	exports.decorateHyper = decorateHyper;

	var _hyperline = __webpack_require__(1);

	var _colors = __webpack_require__(3);

	var _config = __webpack_require__(4);

	var _plugins = __webpack_require__(5);

	var _plugins2 = _interopRequireDefault(_plugins);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	function mapConfigToPluginProp(config) {
	  return config.plugins.map(function (_ref) {
	    var name = _ref.name;
	    var options = _ref.options;
	    return {
	      componentFactory: _plugins2.default[name].componentFactory,
	      options: options
	    };
	  });
	}

	function reduceUI(state, _ref2) {
	  var type = _ref2.type;
	  var config = _ref2.config;

	  switch (type) {
	    case 'CONFIG_LOAD':
	    case 'CONFIG_RELOAD':
	      {
	        return state.set('hyperline', config.hyperline);
	      }
	  }

	  return state;
	}

	function mapHyperState(_ref3, map) {
	  var _ref3$ui = _ref3.ui;
	  var colors = _ref3$ui.colors;
	  var fontFamily = _ref3$ui.fontFamily;
	  var hyperline = _ref3$ui.hyperline;

	  return Object.assign({}, map, {
	    colors: colors,
	    fontFamily: fontFamily,
	    hyperline: hyperline
	  });
	}

	function decorateHyper(Hyper, _ref4) {
	  var React = _ref4.React;
	  var notify = _ref4.notify;
	  var Component = React.Component;
	  var PropTypes = React.PropTypes;

	  var HyperLine = (0, _hyperline.hyperlineFactory)(React);

	  return function (_Component) {
	    _inherits(_class, _Component);

	    _createClass(_class, null, [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'Hyper';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          colors: PropTypes.oneOfType([PropTypes.object, PropTypes.array]),
	          fontFamily: PropTypes.string,
	          style: PropTypes.object,
	          hyperline: PropTypes.object
	        };
	      }
	    }]);

	    function _class(props, context) {
	      _classCallCheck(this, _class);

	      var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(_class).call(this, props, context));

	      _this.colors = (0, _colors.getColorList)(props.colors);

	      var defaultConfig = (0, _config.getDefaultConfig)(_plugins2.default);
	      var mergedConfig = (0, _config.mergeConfigs)(defaultConfig, props.hyperline, notify);

	      _this.plugins = mapConfigToPluginProp(mergedConfig);
	      return _this;
	    }

	    _createClass(_class, [{
	      key: 'render',
	      value: function render() {
	        return React.createElement(Hyper, _extends({}, this.props, { customChildren: React.createElement(HyperLine, {
	            fontFamily: this.props.fontFamily,
	            colors: this.colors,
	            plugins: this.plugins
	          }) }));
	      }
	    }]);

	    return _class;
	  }(Component);
	}

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.hyperlineFactory = undefined;

	var _color = __webpack_require__(2);

	var _color2 = _interopRequireDefault(_color);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	var hyperlineFactory = exports.hyperlineFactory = function hyperlineFactory(React) {
	  var HyperLine = function HyperLine(_ref) {
	    var fontFamily = _ref.fontFamily;
	    var colors = _ref.colors;
	    var plugins = _ref.plugins;

	    var lineStyle = {
	      display: 'flex',
	      alignItems: 'center',
	      position: 'absolute',
	      overflow: 'hidden',
	      bottom: 0,
	      width: '100%',
	      height: '18px',
	      font: 'bold 12px Monospace',
	      pointerEvents: 'none',
	      fontFamily: fontFamily,
	      background: (0, _color2.default)(colors.black).darken(0.1).hslString()
	    };

	    return React.createElement(
	      'div',
	      { style: lineStyle },
	      plugins.map(function (item, index) {
	        var Plugin = item.componentFactory(React, colors);
	        return React.createElement(Plugin, { key: index, options: item.options });
	      })
	    );
	  };

	  HyperLine.propTypes = {
	    fontFamily: React.PropTypes.string.isRequired,
	    colors: React.PropTypes.object.isRequired,
	    plugins: React.PropTypes.array.isRequired
	  };

	  return HyperLine;
	};

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports = require("color");

/***/ },
/* 3 */
/***/ function(module, exports) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.getColorList = getColorList;
	exports.colorExists = colorExists;
	// Taken from https://github.com/zeit/hyper/blob/master/lib/utils/colors.js
	// Effect of this script is the reverse of colors.js in hyper.app
	var colorList = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white', 'lightBlack', 'lightRed', 'lightGreen', 'lightYellow', 'lightBlue', 'lightMagenta', 'lightCyan', 'lightWhite', 'colorCubes', 'grayscale'];

	function getColorList(colors) {
	  // For forwards compatibility, return early if it's already an object
	  if (!Array.isArray(colors)) {
	    return colors;
	  }

	  // For backwards compatibility
	  var colorsList = {};
	  colors.forEach(function (color, index) {
	    colorsList[colorList[index]] = color;
	  });

	  return colorsList;
	}

	function colorExists(name) {
	  return colorList.indexOf(name) !== -1;
	}

/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});

	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol ? "symbol" : typeof obj; };

	exports.getDefaultConfig = getDefaultConfig;
	exports.mergeConfigs = mergeConfigs;

	var _colors = __webpack_require__(3);

	var _plugins = __webpack_require__(5);

	var _plugins2 = _interopRequireDefault(_plugins);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

	function getPluginFromListByName(pluginList, name) {
	  return pluginList.find(function (each) {
	    return each.name === name;
	  });
	}

	function mergeColorConfigs(defaultColor) {
	  var userColor = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];

	  if (!userColor || !(0, _colors.colorExists)(userColor)) {
	    return defaultColor;
	  }

	  return userColor;
	}

	function mergePluginConfigs(defaultPlugins, userPlugins, notify) {
	  if (!userPlugins) {
	    return defaultPlugins;
	  }

	  return userPlugins.reduce(function (newPlugins, plugin) {
	    var newPlugin = Object.assign({}, plugin);
	    var name = plugin.name;
	    var _plugin$options = plugin.options;
	    var options = _plugin$options === undefined ? false : _plugin$options;


	    if ((typeof plugin === 'undefined' ? 'undefined' : _typeof(plugin)) !== 'object' || Array.isArray(plugin)) {
	      notify('HyperLine', '\'plugins\' array members in \'.hyper.js\' must be objects.');
	      return newPlugins;
	    }

	    var _getPluginFromListByN = getPluginFromListByName(defaultPlugins, name);

	    var _getPluginFromListByN2 = _getPluginFromListByN.options;
	    var defaultOptions = _getPluginFromListByN2 === undefined ? false : _getPluginFromListByN2;


	    if (!defaultOptions) {
	      notify('HyperLine', 'Plugin with name "' + name + '" does not exist.');
	      return newPlugins;
	    }

	    if (options) {
	      newPlugin.options = defaultOptions;
	    }

	    var _plugins$name$validat = _plugins2.default[name].validateOptions;
	    var validator = _plugins$name$validat === undefined ? false : _plugins$name$validat;

	    if (validator) {
	      var errors = validator(options);
	      if (errors.length > 0) {
	        errors.forEach(function (error) {
	          return notify('HyperLine \'' + name + '\' plugin', error);
	        });
	        newPlugin.options = defaultOptions;
	      }
	    }

	    return [].concat(_toConsumableArray(newPlugins), [plugin]);
	  }, []);
	}

	function getDefaultConfig(plugins) {
	  return {
	    color: 'black',
	    plugins: Object.keys(plugins).reduce(function (pluginsArray, pluginName) {
	      var defaultOptions = plugins[pluginName].defaultOptions;


	      var plugin = {
	        name: pluginName,
	        options: defaultOptions
	      };

	      return [].concat(_toConsumableArray(pluginsArray), [plugin]);
	    }, [])
	  };
	}

	function mergeConfigs(defaultConfig) {
	  var userConfig = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	  var notify = arguments[2];

	  if (!userConfig) {
	    return defaultConfig;
	  }

	  return {
	    color: mergeColorConfigs(defaultConfig.color, userConfig.color),
	    plugins: mergePluginConfigs(defaultConfig.plugins, userConfig.plugins, notify)
	  };
	}

/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});

	var _hostname = __webpack_require__(6);

	var hostname = _interopRequireWildcard(_hostname);

	var _memory = __webpack_require__(10);

	var memory = _interopRequireWildcard(_memory);

	var _uptime = __webpack_require__(12);

	var uptime = _interopRequireWildcard(_uptime);

	var _cpu = __webpack_require__(13);

	var cpu = _interopRequireWildcard(_cpu);

	var _network = __webpack_require__(14);

	var network = _interopRequireWildcard(_network);

	var _battery = __webpack_require__(15);

	var battery = _interopRequireWildcard(_battery);

	function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

	/**
	 * Exports a mapping from plugin name to associated component factory.
	 * Object keys match those used in the configuration object
	 */
	exports.default = { hostname: hostname, memory: memory, uptime: uptime, cpu: cpu, network: network, battery: battery };

/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.defaultOptions = exports.validateOptions = undefined;

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.componentFactory = componentFactory;

	var _os = __webpack_require__(7);

	var _os2 = _interopRequireDefault(_os);

	var _icons = __webpack_require__(8);

	var _colors = __webpack_require__(3);

	var _PluginWrapper = __webpack_require__(9);

	var _PluginWrapper2 = _interopRequireDefault(_PluginWrapper);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	function componentFactory(React, colors) {
	  var PluginIcon = function PluginIcon(_ref) {
	    var fillColor = _ref.fillColor;
	    return React.createElement(
	      'svg',
	      { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	      React.createElement(
	        'g',
	        { fill: 'none', fillRule: 'evenodd' },
	        React.createElement(
	          'g',
	          { fill: fillColor, transform: 'translate(1.000000, 1.000000)' },
	          React.createElement('path', { d: 'M2,0 L12,0 L12,8 L2,8 L2,0 Z M4,2 L10,2 L10,6 L4,6 L4,2 Z M5.5,11 L8.5,11 L8.5,14 L5.5,14 L5.5,11 Z M11,11 L14,11 L14,14 L11,14 L11,11 Z M0,11 L3,11 L3,14 L0,14 L0,11 Z M6.5,10 L7.5,10 L7.5,11 L6.5,11 L6.5,10 Z M12,10 L13,10 L13,11 L12,11 L12,10 Z M1,10 L2,10 L2,11 L1,11 L1,10 Z M1,9 L13,9 L13,10 L1,10 L1,9 Z M6.5,8 L7.5,8 L7.5,9 L6.5,9 L6.5,8 Z' })
	        )
	      )
	    );
	  };

	  PluginIcon.propTypes = {
	    fillColor: React.PropTypes.string
	  };

	  return function (_React$Component) {
	    _inherits(_class, _React$Component);

	    function _class() {
	      _classCallCheck(this, _class);

	      return _possibleConstructorReturn(this, Object.getPrototypeOf(_class).apply(this, arguments));
	    }

	    _createClass(_class, [{
	      key: 'render',
	      value: function render() {
	        var PluginWrapper = (0, _PluginWrapper2.default)(React);
	        var fillColor = colors[this.props.options.color];

	        return React.createElement(
	          PluginWrapper,
	          { color: fillColor },
	          React.createElement(PluginIcon, { fillColor: fillColor }),
	          ' ',
	          _os2.default.hostname()
	        );
	      }
	    }], [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'Hostname plugin';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          options: React.PropTypes.object
	        };
	      }
	    }]);

	    return _class;
	  }(React.Component);
	}

	var validateOptions = exports.validateOptions = function validateOptions(options) {
	  var errors = [];

	  if (!options.color) {
	    errors.push('\'color\' color string is required but missing.');
	  } else if (!(0, _colors.colorExists)(options.color)) {
	    errors.push('invalid color \'' + options.color + '\'');
	  }

	  return errors;
	};

	var defaultOptions = exports.defaultOptions = {
	  color: 'lightBlue'
	};

/***/ },
/* 7 */
/***/ function(module, exports) {

	module.exports = require("os");

/***/ },
/* 8 */
/***/ function(module, exports) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	var iconStyles = exports.iconStyles = {
	  marginRight: '7px',
	  width: '16px',
	  height: '16px'
	};

/***/ },
/* 9 */
/***/ function(module, exports) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});

	exports.default = function (React) {
	  var PluginWrapper = function PluginWrapper(_ref) {
	    var color = _ref.color;
	    var children = _ref.children;

	    var style = {
	      display: 'flex',
	      flexShrink: '0',
	      alignItems: 'center',
	      paddingLeft: '7px',
	      paddingRight: '7px',
	      borderLeft: '1px',
	      borderTop: '0px',
	      borderRight: '0px',
	      borderBottom: '0px',
	      borderStyle: 'solid',
	      borderColor: 'rgba(255, 255, 255, .2)'
	    };

	    if (color) {
	      style.color = color;
	    }

	    return React.createElement(
	      'div',
	      { style: style },
	      children
	    );
	  };

	  PluginWrapper.propTypes = {
	    color: React.PropTypes.string,
	    children: React.PropTypes.any
	  };

	  return PluginWrapper;
	};

/***/ },
/* 10 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.defaultOptions = exports.validateOptions = undefined;

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.componentFactory = componentFactory;

	var _systeminformation = __webpack_require__(11);

	var _icons = __webpack_require__(8);

	var _colors = __webpack_require__(3);

	var _PluginWrapper = __webpack_require__(9);

	var _PluginWrapper2 = _interopRequireDefault(_PluginWrapper);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	function componentFactory(React, colors) {
	  var Component = React.Component;
	  var PropTypes = React.PropTypes;


	  var PluginIcon = function PluginIcon(_ref) {
	    var fillColor = _ref.fillColor;
	    return React.createElement(
	      'svg',
	      { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	      React.createElement(
	        'g',
	        { fill: 'none', fillRule: 'evenodd' },
	        React.createElement(
	          'g',
	          { fill: fillColor },
	          React.createElement(
	            'g',
	            { id: 'memory', transform: 'translate(1.000000, 1.000000)' },
	            React.createElement('path', { d: 'M3,0 L11,0 L11,14 L3,14 L3,0 Z M4,1 L10,1 L10,13 L4,13 L4,1 Z' }),
	            React.createElement('rect', { x: '5', y: '2', width: '4', height: '10' }),
	            React.createElement('rect', { x: '12', y: '1', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '3', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '5', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '9', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '7', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '11', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '1', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '3', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '5', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '9', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '7', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '11', width: '2', height: '1' })
	          )
	        )
	      )
	    );
	  };

	  PluginIcon.propTypes = {
	    fillColor: PropTypes.string
	  };

	  return function (_Component) {
	    _inherits(_class, _Component);

	    _createClass(_class, null, [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'Memory plugin';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          options: PropTypes.object
	        };
	      }
	    }]);

	    function _class(props) {
	      _classCallCheck(this, _class);

	      var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(_class).call(this, props));

	      _this.state = {
	        activeMemory: 0,
	        totalMemory: 0
	      };

	      (0, _systeminformation.mem)().then(function (m) {
	        _this.state = {
	          activeMemory: _this.getMb(m.active),
	          totalMemory: _this.getMb(m.total)
	        };
	      });

	      return _this;
	    }

	    _createClass(_class, [{
	      key: 'componentDidMount',
	      value: function componentDidMount() {
	        var _this2 = this;

	        this.interval = setInterval(function () {
	          return (0, _systeminformation.mem)().then(function (m) {
	            _this2.setState({ activeMemory: _this2.getMb(m.active) });
	          });
	        }, 1000);
	      }
	    }, {
	      key: 'componentWillUnmount',
	      value: function componentWillUnmount() {
	        clearInterval(this.interval);
	      }
	    }, {
	      key: 'getMb',
	      value: function getMb(bytes) {
	        return (bytes / (1024 * 1024)).toFixed(0) + 'MB';
	      }
	    }, {
	      key: 'render',
	      value: function render() {
	        var PluginWrapper = (0, _PluginWrapper2.default)(React);
	        var fillColor = colors[this.props.options.color];

	        return React.createElement(
	          PluginWrapper,
	          { color: fillColor },
	          React.createElement(PluginIcon, { fillColor: fillColor }),
	          ' ',
	          this.state.activeMemory,
	          ' / ',
	          this.state.totalMemory
	        );
	      }
	    }]);

	    return _class;
	  }(Component);
	}

	var validateOptions = exports.validateOptions = function validateOptions(options) {
	  var errors = [];

	  if (!options.color) {
	    errors.push('\'color\' color string is required but missing.');
	  } else if (!(0, _colors.colorExists)(options.color)) {
	    errors.push('invalid color \'' + options.color + '\'');
	  }

	  return errors;
	};

	var defaultOptions = exports.defaultOptions = {
	  color: 'white'
	};

/***/ },
/* 11 */
/***/ function(module, exports) {

	module.exports = require("systeminformation");

/***/ },
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.defaultOptions = exports.validateOptions = undefined;

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.componentFactory = componentFactory;

	var _os = __webpack_require__(7);

	var _os2 = _interopRequireDefault(_os);

	var _icons = __webpack_require__(8);

	var _PluginWrapper = __webpack_require__(9);

	var _PluginWrapper2 = _interopRequireDefault(_PluginWrapper);

	var _colors = __webpack_require__(3);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	var pluginIcon = function pluginIcon(React, fillColor) {
	  return React.createElement(
	    'svg',
	    { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	    React.createElement(
	      'g',
	      { fill: 'none', fillRule: 'evenodd' },
	      React.createElement(
	        'g',
	        { fill: fillColor, transform: 'translate(1.000000, 1.000000)' },
	        React.createElement(
	          'g',
	          null,
	          React.createElement('path', { d: 'M0,0 L14,0 L14,14 L0,14 L0,0 Z M1,1 L13,1 L13,13 L1,13 L1,1 Z' }),
	          React.createElement('path', { d: 'M6,2 L7,2 L7,7 L6,7 L6,2 Z M6,7 L10,7 L10,8 L6,8 L6,7 Z' })
	        )
	      )
	    )
	  );
	};

	function componentFactory(React, colors) {
	  var Component = React.Component;
	  var PropTypes = React.PropTypes;

	  return function (_Component) {
	    _inherits(_class, _Component);

	    _createClass(_class, null, [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'Uptime plugin';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          options: PropTypes.object
	        };
	      }
	    }]);

	    function _class(props) {
	      _classCallCheck(this, _class);

	      var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(_class).call(this, props));

	      _this.state = {
	        uptime: _this.getUptime()
	      };
	      return _this;
	    }

	    _createClass(_class, [{
	      key: 'componentDidMount',
	      value: function componentDidMount() {
	        var _this2 = this;

	        // Recheck every 5 minutes
	        setInterval(function () {
	          return {
	            uptime: _this2.setState(_this2.getUptime())
	          };
	        }, 60000 * 5);
	      }
	    }, {
	      key: 'getUptime',
	      value: function getUptime() {
	        return (_os2.default.uptime() / 3600).toFixed(0);
	      }
	    }, {
	      key: 'render',
	      value: function render() {
	        var PluginWrapper = (0, _PluginWrapper2.default)(React);
	        var fillColor = colors[this.props.options.color];

	        return React.createElement(
	          PluginWrapper,
	          { color: fillColor },
	          pluginIcon(React, fillColor),
	          ' ',
	          this.state.uptime,
	          'HRS'
	        );
	      }
	    }]);

	    return _class;
	  }(Component);
	}

	var validateOptions = exports.validateOptions = function validateOptions(options) {
	  var errors = [];

	  if (!options.color) {
	    errors.push('\'color\' color string is required but missing.');
	  } else if (!(0, _colors.colorExists)(options.color)) {
	    errors.push('invalid color \'' + options.color + '\'');
	  }

	  return errors;
	};

	var defaultOptions = exports.defaultOptions = {
	  color: 'lightYellow'
	};

/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.defaultOptions = exports.validateOptions = undefined;

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.componentFactory = componentFactory;

	var _os = __webpack_require__(7);

	var _os2 = _interopRequireDefault(_os);

	var _icons = __webpack_require__(8);

	var _colors = __webpack_require__(3);

	var _PluginWrapper = __webpack_require__(9);

	var _PluginWrapper2 = _interopRequireDefault(_PluginWrapper);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	function componentFactory(React, colors) {
	  var Component = React.Component;
	  var PropTypes = React.PropTypes;


	  var PluginIcon = function PluginIcon(_ref) {
	    var fillColor = _ref.fillColor;
	    return React.createElement(
	      'svg',
	      { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	      React.createElement(
	        'g',
	        { fill: 'none', fillRule: 'evenodd' },
	        React.createElement(
	          'g',
	          { fill: fillColor, transform: 'translate(1.000000, 1.000000)' },
	          React.createElement(
	            'g',
	            null,
	            React.createElement('path', { d: 'M3,3 L11,3 L11,11 L3,11 L3,3 Z M4,4 L10,4 L10,10 L4,10 L4,4 Z' }),
	            React.createElement('rect', { x: '5', y: '5', width: '4', height: '4' }),
	            React.createElement('rect', { x: '4', y: '0', width: '1', height: '2' }),
	            React.createElement('rect', { x: '6', y: '0', width: '1', height: '2' }),
	            React.createElement('rect', { x: '8', y: '0', width: '1', height: '2' }),
	            React.createElement('rect', { x: '5', y: '12', width: '1', height: '2' }),
	            React.createElement('rect', { x: '7', y: '12', width: '1', height: '2' }),
	            React.createElement('rect', { x: '9', y: '12', width: '1', height: '2' }),
	            React.createElement('rect', { x: '12', y: '3', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '5', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '7', width: '2', height: '1' }),
	            React.createElement('rect', { x: '12', y: '9', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '4', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '4', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '6', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '8', width: '2', height: '1' }),
	            React.createElement('rect', { x: '0', y: '10', width: '2', height: '1' })
	          )
	        )
	      )
	    );
	  };

	  PluginIcon.propTypes = {
	    fillColor: PropTypes.string
	  };

	  return function (_Component) {
	    _inherits(_class, _Component);

	    _createClass(_class, null, [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'CPU plugin';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          options: PropTypes.object
	        };
	      }
	    }]);

	    function _class(props) {
	      _classCallCheck(this, _class);

	      var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(_class).call(this, props));

	      _this.state = {
	        cpuAverage: _this.calculateCpuUsage()
	      };

	      _this.info = {
	        idleCpu: false,
	        totalCpu: false
	      };
	      return _this;
	    }

	    _createClass(_class, [{
	      key: 'componentDidMount',
	      value: function componentDidMount() {
	        var _this2 = this;

	        this.interval = setInterval(function () {
	          _this2.setState({
	            cpuAverage: _this2.calculateCpuUsage()
	          });
	        }, 500);
	      }
	    }, {
	      key: 'componentWillUnmount',
	      value: function componentWillUnmount() {
	        clearInterval(this.interval);
	      }
	    }, {
	      key: 'calculateCpuUsage',
	      value: function calculateCpuUsage() {
	        var totalIdle = 0,
	            totalTick = 0,
	            idle = void 0,
	            total = void 0,
	            averageCpuUsage = void 0;

	        var cpus = _os2.default.cpus();

	        for (var i = 0, len = cpus.length; i < len; i++) {
	          var cpu = cpus[i];

	          for (var type in cpu.times) {
	            if (cpu.times.hasOwnProperty(type)) {
	              totalTick += cpu.times[type];
	            }
	          }

	          totalIdle += cpu.times.idle;
	        }

	        idle = totalIdle / cpus.length;
	        total = totalTick / cpus.length;

	        if (this.info && this.info.idleCpu) {
	          var idleDifference = idle - this.info.idleCpu,
	              totalDifference = total - this.info.totalCpu;
	          averageCpuUsage = 100 - ~~(100 * idleDifference / totalDifference);
	        } else {
	          averageCpuUsage = 0;
	        }

	        this.info = {
	          idleCpu: idle,
	          totalCpu: total
	        };

	        return averageCpuUsage;
	      }
	    }, {
	      key: 'getColor',
	      value: function getColor(cpuAverage) {
	        var colors = this.props.options.colors;

	        if (cpuAverage < 50) {
	          return colors.low;
	        } else if (cpuAverage < 75) {
	          return colors.moderate;
	        } else {
	          return colors.high;
	        }
	      }
	    }, {
	      key: 'render',
	      value: function render() {
	        var avg = this.state.cpuAverage.toFixed(0);
	        var PluginWrapper = (0, _PluginWrapper2.default)(React);
	        var fillColor = colors[this.getColor(this.state.cpuAverage)];

	        return React.createElement(
	          PluginWrapper,
	          { color: fillColor },
	          React.createElement(PluginIcon, { fillColor: fillColor }),
	          ' ',
	          avg,
	          '%'
	        );
	      }
	    }]);

	    return _class;
	  }(Component);
	}

	var validateOptions = exports.validateOptions = function validateOptions(_ref2) {
	  var _ref2$colors = _ref2.colors;
	  var colors = _ref2$colors === undefined ? false : _ref2$colors;

	  var errors = [];

	  if (!colors) {
	    errors.push('\'colors\' object is required but missing.');
	  } else {
	    if (!colors.high) {
	      errors.push('\'colors.high\' color string is required but missing.');
	    } else if (!(0, _colors.colorExists)(colors.high)) {
	      errors.push('invalid color \'' + colors.high + '\'');
	    }

	    if (!colors.moderate) {
	      errors.push('\'colors.moderate\' color string is required but missing.');
	    } else if (!(0, _colors.colorExists)(colors.moderate)) {
	      errors.push('invalid color \'' + colors.moderate + '\'');
	    }

	    if (!colors.low) {
	      errors.push('\'colors.low\' color string is required but missing.');
	    } else if (!(0, _colors.colorExists)(colors.low)) {
	      errors.push('invalid color \'' + colors.low + '\'');
	    }
	  }

	  return errors;
	};

	var defaultOptions = exports.defaultOptions = {
	  colors: {
	    high: 'lightRed',
	    moderate: 'lightYellow',
	    low: 'lightGreen'
	  }
	};

/***/ },
/* 14 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.defaultOptions = exports.validateOptions = undefined;

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.componentFactory = componentFactory;

	var _systeminformation = __webpack_require__(11);

	var _icons = __webpack_require__(8);

	var _colors = __webpack_require__(3);

	var _PluginWrapper = __webpack_require__(9);

	var _PluginWrapper2 = _interopRequireDefault(_PluginWrapper);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	function componentFactory(React, colors) {
	  var Component = React.Component;
	  var PropTypes = React.PropTypes;


	  var PluginIcon = function PluginIcon(_ref) {
	    var fillColor = _ref.fillColor;
	    return React.createElement(
	      'svg',
	      { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	      React.createElement(
	        'g',
	        { fill: 'none', fillRule: 'evenodd' },
	        React.createElement(
	          'g',
	          { fill: fillColor, transform: 'translate(1.000000, 1.000000)' },
	          React.createElement(
	            'g',
	            null,
	            React.createElement('path', { d: 'M0,10 L7,10 L7,11 L0,11 L0,10 Z M1,11 L6,11 L6,12 L1,12 L1,11 Z M2,12 L5,12 L5,13 L2,13 L2,12 Z M3,13 L4,13 L4,14 L3,14 L3,13 Z M2,3 L5,3 L5,10 L2,10 L2,3 Z' }),
	            React.createElement('path', { d: 'M8,2 L13,2 L13,3 L8,3 L8,2 Z M9,1 L12,1 L12,2 L9,2 L9,1 Z M10,0 L11,0 L11,1 L10,1 L10,0 Z M7,3 L14,3 L14,4 L7,4 L7,3 Z M9,4 L12,4 L12,11 L9,11 L9,4 Z' })
	          )
	        )
	      )
	    );
	  };

	  PluginIcon.propTypes = {
	    fillColor: PropTypes.string
	  };

	  return function (_Component) {
	    _inherits(_class, _Component);

	    _createClass(_class, null, [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'Network Speed plugin';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          options: PropTypes.object
	        };
	      }
	    }]);

	    function _class(props) {
	      _classCallCheck(this, _class);

	      var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(_class).call(this, props));

	      _this.state = {
	        download: 0,
	        upload: 0
	      };

	      _this.networkPromises = [];
	      return _this;
	    }

	    _createClass(_class, [{
	      key: 'componentDidMount',
	      value: function componentDidMount() {
	        var _this2 = this;

	        this.getSpeed();
	        this.interval = setInterval(function () {
	          return _this2.getSpeed();
	        }, 500);
	      }
	    }, {
	      key: 'componentWillUnmount',
	      value: function componentWillUnmount() {
	        clearInterval(this.interval);
	        this.networkPromises.reduce(function (items, item) {
	          if (typeof item.cancel !== 'undefined') {
	            item.cancel();
	          }
	          return [].concat(_toConsumableArray(items), [item]);
	        }, []);
	      }
	    }, {
	      key: 'getSpeed',
	      value: function getSpeed() {
	        var _this3 = this;

	        this.networkPromises.push((0, _systeminformation.networkStats)().then(function (data) {
	          return _this3.setState(_this3.buildStateObject(data));
	        }));
	      }
	    }, {
	      key: 'buildStateObject',
	      value: function buildStateObject(data) {
	        var rawDownload = data.rx_sec / 1024;
	        if (rawDownload < 0 || isNaN(rawDownload)) {
	          rawDownload = 0;
	        }

	        var rawUpload = data.tx_sec / 1024;
	        if (rawUpload < 0 || isNaN(rawUpload)) {
	          rawUpload = 0;
	        }

	        return Object.assign({}, {
	          download: rawDownload.toFixed(),
	          upload: rawUpload.toFixed()
	        });
	      }
	    }, {
	      key: 'render',
	      value: function render() {
	        var PluginWrapper = (0, _PluginWrapper2.default)(React);
	        var fillColor = colors[this.props.options.color];

	        return React.createElement(
	          PluginWrapper,
	          { color: fillColor },
	          React.createElement(PluginIcon, { fillColor: fillColor }),
	          ' ',
	          this.state.download,
	          'kB/s ',
	          this.state.upload,
	          'kB/s'
	        );
	      }
	    }]);

	    return _class;
	  }(Component);
	}

	var validateOptions = exports.validateOptions = function validateOptions(options) {
	  var errors = [];

	  if (!options.color) {
	    errors.push('\'color\' color string is required but missing.');
	  } else if (!(0, _colors.colorExists)(options.color)) {
	    errors.push('invalid color \'' + options.color + '\'');
	  }

	  return errors;
	};

	var defaultOptions = exports.defaultOptions = {
	  color: 'lightCyan'
	};

/***/ },
/* 15 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.defaultOptions = exports.validateOptions = undefined;

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	exports.componentFactory = componentFactory;

	var _icons = __webpack_require__(8);

	var _colors = __webpack_require__(3);

	var _PluginWrapper = __webpack_require__(9);

	var _PluginWrapper2 = _interopRequireDefault(_PluginWrapper);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	function componentFactory(React, colors) {
	  var Component = React.Component;
	  var PropTypes = React.PropTypes;


	  var PluginIcon = function PluginIcon(_ref) {
	    var state = _ref.state;
	    var fillColor = _ref.fillColor;

	    var calcCharge = function calcCharge(percent) {
	      var base = 3.5,
	          val = Math.round((100 - percent) / 4.5),
	          point = base + val / 2;

	      return val > 0 ? 'M5,3 L11,3 L11,' + point + ' L5,' + point + ' L5,3 Z' : '';
	    };

	    var states = {
	      CHARGING: React.createElement(
	        'svg',
	        { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	        React.createElement(
	          'g',
	          { fillRule: 'evenodd' },
	          React.createElement(
	            'g',
	            { fill: fillColor },
	            React.createElement('path', { d: 'M9,10 L10,10 L10,9 L6,9 L6,10 L7,10 L7,13 L9,13 L9,10 Z M7,1 L9,1 L9,2 L7,2 L7,1 Z M4,2 L12,2 L12,15 L4,15 L4,2 Z M5,6 L11,6 L11,7 L5,7 L5,6 Z M5,7 L11,7 L11,8 L5,8 L5,7 Z M5,8 L11,8 L11,9 L5,9 L5,8 Z M9,4 L10,4 L10,6 L9,6 L9,4 Z M6,4 L7,4 L7,6 L6,6 L6,4 Z' })
	          )
	        )
	      ),
	      DISCHARGING: React.createElement(
	        'svg',
	        { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	        React.createElement(
	          'g',
	          { fillRule: 'evenodd' },
	          React.createElement(
	            'g',
	            { fill: fillColor },
	            React.createElement('path', { d: 'M7,1 L9,1 L9,2 L7,2 L7,1 Z M4,2 L12,2 L12,15 L4,15 L4,2 Z ' + calcCharge(state.percent) })
	          )
	        )
	      ),
	      CRITICAL: React.createElement(
	        'svg',
	        { style: _icons.iconStyles, xmlns: 'http://www.w3.org/2000/svg' },
	        React.createElement(
	          'g',
	          { fillRule: 'evenodd' },
	          React.createElement(
	            'g',
	            { fill: fillColor },
	            React.createElement('path', { d: 'M7,1 L9,1 L9,2 L7,2 L7,1 Z M4,2 L12,2 L12,15 L4,15 L4,2 Z M5,3 L11,3 L11,11 L5,11 L5,3 Z' })
	          )
	        )
	      )
	    };

	    if (state.percent <= 20 && !state.ischarging) {
	      return states.CRITICAL;
	    } else if (!state.ischarging) {
	      return states.DISCHARGING;
	    }

	    return states.CHARGING;
	  };

	  return function (_Component) {
	    _inherits(_class, _Component);

	    _createClass(_class, null, [{
	      key: 'displayName',
	      value: function displayName() {
	        return 'Battery plugin';
	      }
	    }, {
	      key: 'propTypes',
	      value: function propTypes() {
	        return {
	          options: PropTypes.object
	        };
	      }
	    }]);

	    function _class(props) {
	      _classCallCheck(this, _class);

	      var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(_class).call(this, props));

	      _this.state = {
	        ischarging: false,
	        percent: '--'
	      };

	      _this.batteryEvents = ['chargingchange', 'chargingtimechange', 'dischargingtimechange', 'levelchange'];
	      _this.handleEvent = _this.handleEvent.bind(_this);
	      return _this;
	    }

	    _createClass(_class, [{
	      key: 'componentDidMount',
	      value: function componentDidMount() {
	        var _this2 = this;

	        navigator.getBattery().then(function (battery) {
	          _this2.setBatteryStatus(battery);

	          _this2.batteryEvents.forEach(function (event) {
	            battery.addEventListener(event, _this2.handleEvent, false);
	          });
	        });
	      }
	    }, {
	      key: 'componentWillUnmount',
	      value: function componentWillUnmount() {
	        var _this3 = this;

	        navigator.getBattery().then(function (battery) {
	          _this3.batteryEvents.forEach(function (event) {
	            battery.removeEventListener(event, _this3.handleEvent);
	          });
	        });
	      }
	    }, {
	      key: 'handleEvent',
	      value: function handleEvent(event) {
	        this.setBatteryStatus(event.target);
	      }
	    }, {
	      key: 'setBatteryStatus',
	      value: function setBatteryStatus(battery) {
	        this.setState(Object.assign({}, {
	          ischarging: battery.charging,
	          percent: Math.floor(battery.level * 100)
	        }));
	      }
	    }, {
	      key: 'getColor',
	      value: function getColor(batteryState) {
	        var colors = this.props.options.colors;

	        if (batteryState.percent <= 20 && !batteryState.ischarging) {
	          return colors.critical;
	        }

	        return colors.fine;
	      }
	    }, {
	      key: 'render',
	      value: function render() {
	        var PluginWrapper = (0, _PluginWrapper2.default)(React);
	        var fillColor = colors[this.getColor(this.state)];

	        return React.createElement(
	          PluginWrapper,
	          { color: fillColor },
	          React.createElement(PluginIcon, { state: this.state, fillColor: fillColor }),
	          ' ',
	          this.state.percent,
	          '%'
	        );
	      }
	    }]);

	    return _class;
	  }(Component);
	}

	var validateOptions = exports.validateOptions = function validateOptions(options) {
	  var errors = [];

	  if (!options.colors) {
	    errors.push('\'colors\' object is required but missing.');
	  } else {
	    if (!options.colors.fine) {
	      errors.push('\'colors.fine\' color string is required but missing.');
	    } else if (!(0, _colors.colorExists)(options.colors.fine)) {
	      errors.push('invalid color \'' + options.colors.fine + '\'');
	    }

	    if (!options.colors.critical) {
	      errors.push('\'colors.critical\' color string is required but missing.');
	    } else if (!(0, _colors.colorExists)(options.colors.critical)) {
	      errors.push('invalid color \'' + options.colors.critical + '\'');
	    }
	  }

	  return errors;
	};

	var defaultOptions = exports.defaultOptions = {
	  colors: {
	    fine: 'lightGreen',
	    critical: 'lightRed'
	  }
	};

/***/ }
/******/ ])));