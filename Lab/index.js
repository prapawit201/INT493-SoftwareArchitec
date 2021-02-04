const express = require('express')
const app = express()
const PORT = process.env.PORT || 8080
const bodyParser = require('body-parser')
const cors = require('cors')
const routes = require('./router/indexRoutes')
app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

app.use(routes)

app.listen(PORT,()=>{
    console.log('start server port : '+PORT) + ' ..';
})