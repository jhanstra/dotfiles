
const $1 = async (req, res) => {
  if (req.method === 'POST') {
    const { $2 } = req.body

    try {
      $3

      return res.status(200).json($4)
    } catch (err) {
      console.log(err)
      res.status(500).json({ error: { statusCode: 500, message: err.message } })
    }
  } else {
    res.setHeader('Allow', 'POST')
    res.status(405).end('Method Not Allowed')
  }
}

export default $1
