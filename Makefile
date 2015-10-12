all: readme

readme:
	markedpp --githubid -i README.md -o README.md

.PHONY:
	readme
