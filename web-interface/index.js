const express = require('express')
const exphbs = require('express-handlebars')
const { spawn } = require('child_process')

const app = express()

const registers = [
	{
		name: 'r0',
		types: [
			{ id: 'int', name: 'Integer' }
		]
	}
]

app.use(express.urlencoded())
app.engine('handlebars', exphbs({ defaultLayout: 'main' }))
app.set('view engine', 'handlebars')

app.get('/', (req, res) => {
	res.render('home')
})

app.get('/form', (req, res) => {
	res.render('form', {
		registers,
		code: ''
	})
})

app.post('/form', (req, res) => {
	console.log('POST request received')
	console.log(req.body)
	const proc = spawn('../engine/exec.sh', registers.map((_, i) => `${req.body[`type${i}`]}:${req.body[`value${i}`]}`))
	console.log('process spawned')
	let out = ''
	proc.stdout.on('data', data => out += data.toString())
	proc.stderr.on('data', data => out += data.toString())
	proc.stdin.write(req.body.code)
	proc.stdin.end()
	proc.on('close', result => {
		console.log(result)
		res.render('form', {
			registers: registers.map((r, i) => Object.assign({
				value: req.body[`value${i}`]
			}, r, {
				types: r.types.map(t => Object.assign({
					selected: t.id === req.body[`type${i}`]
				}, t))
			})),
			code: req.body.code,
			result,
			out
		})
	})
	console.log('end')
})

app.listen(8085)
console.log('Server started')
