git submodule update --init --recursive
mkdir -p work_farm/target/
cd work_farm/target && ln -s ../../nanhu-g nanhu-g
cd ../ && ln -s ../shell shell
ln -s ../tools/ tools