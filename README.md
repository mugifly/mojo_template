mojo_template by masanori.
====

# Usage (Appname: "HogeHoge")
	cd site_template/
	find . -name "exmaple" | xargs sed -i "s/Example/HogeHoge/g"
	find . -name "*.pm" | xargs sed -i "s/Example/HogeHoge/g"
	find . -name "*.ep" | xargs sed -i "s/Example/HogeHoge/g"
	find . -name "example" | while read file; do mv $line `echo $file | sed -e 's/example/HogeHoge/'`; done
	find . -name "*.pm" | while read file; do mv $line `echo $file | sed -e 's/Example/HogeHoge/'`; done