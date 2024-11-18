const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('<h1>EC2 Auto Scaling demo v1.0.0</h1>');
})

app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`);
})
