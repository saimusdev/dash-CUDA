# [CUDA](http://www.nvidia.com/object/cuda_home_new.html) Dash docset


[CUDA](http://www.nvidia.com/object/cuda_home_new.html) documentation for Dash

#### Docset unusable for the time being. 

This docset is to be used with [Dash for Mac](http://kapeli.com/dash), or [Zeal docs]( http://zealdocs.org) (which is available for Windows and many Linux distros).


## Basic Installation

* If you plan on using it with **Dash**, `create_docset_orig.sh` will copy the [CUDA]() docset to '/Users/username/Library/Application Support/Dash/Docsets/' automatically. Visit [Dash](http://kapeli.com/dash) website for more info.
* If you're going to use it with **Zeal** you'll find where to store the [CUDA]() in the application 'Options' menu. Visit [their Github page](https://github.com/jkozera/zeal) for more info. 


## Manual Build

Basically, execute the following commands:

```
git clone https://github.com/simioprg/dash-CUDA.git
cd dash-CUDA
./create_docset_orig.sh
cd ..
rm -rf dash-foundation
```

### Notes

Because the script provided downloads the full documentation recursively from the [CUDA website](http://docs.nvidia.com/cuda), it takes some time to download all the files. At least 5-15 minutes will be necessary. It depends on the connection speed, but please be patient.
