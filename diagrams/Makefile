.PHONY: compile
compile:
	./mmdc -i a.mmd -o output.svg
	convert output.svg output.pdf
	#firefox output.svg

.PHONY: watch
watch: compile
	okular output.pdf &
	find . | entr make compile
