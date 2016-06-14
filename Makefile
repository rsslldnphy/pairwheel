run:
	python -m SimpleHTTPServer

auto:
	find . -name *.elm | entr elm make Pairwheel.elm --output=pairwheel.js
