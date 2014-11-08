default: docs

docs:
	mkdir -p ../hook-ruby-docs
	./bin/yard doc -o ../hook-ruby-docs
	git init ../hook-ruby-docs
	cd ../hook-ruby-docs && git remote add origin git@github.com:doubleleft/hook-ruby.git && git checkout -b gh-pages && git add .  && git commit -m "update public documentation" && git push origin gh-pages -f
