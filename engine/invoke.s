	.text
	.arm

	.globl _invoke
_invoke:
	push	{fp, lr}
	push	{r0-r2}
	mov	r1, sp
	bl	setup
	pop	{r0-r3}
	bl	test
	add	sp, #12
	pop	{fp, pc}
