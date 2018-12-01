const express = require('express')
const exphbs = require('express-handlebars')
const exec = require('child_process').exec

const app = express()

app.engine('handlebars', exphbs({ defaultLayout: 'main' }))
app.set('view engine', 'handlebars')

app.get('/', (req, res) => {
	res.render('home')
})

app.get('/form', (req, res) => {
	res.render('form', {
		registers: [
			{
				name: 'r0',
				types: [
					{ id: 'int', name: 'Integer' }
				]
			}
		],
		code: ''
	})
})

app.listen(8080)
