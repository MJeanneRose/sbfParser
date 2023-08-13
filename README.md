# SBF_PARSER

A Python module to read "Septentrio Binary Format" (SBF) files generated by Septentrio receivers.

### Required:

```bash
sudo apt install gcc python3 python3-setuptools python3-dev
python3 -m venv venv
source venv/bin/activate
pip install cython
```

## Installation

>python3 setup.py build

>python3 setup.py build_ext --inplace

>python3 setup.py install

## Release Notes

* Up to 100x times faster parsing (than pure Python, thanks to Cython). Python module is written in C and complied for C-like speeds.
* All blocks documented in documentation v1.14.0 are supported.

## Usage

The basic function of this module is to parse every block inside a SBF file into a map.
Therefore, the `dict` built-in Python object is used to represent each block. 

### Functions

#### `load(f_obj, blocknames=set())`:
Returns a iterator/generator of SBF blocks.  
`f_obj` should be a file object.  

By default every type of block is generated, however most of the time only certain types
of blocks are needed. This can be accomplished by providing a set of block names to 
the `blocknames` parameter.  

## Examples

Print the block name and block content:

```python
import sbf_parser
    
with open('./dummy.sbf') as sbf_fobj:
 for blockName, block in sbfParser.load(sbf_fobj):
  print(blockName)
  print(block)
```
      
Print the azimuth & elevation for each visible satellite using the *SatVisibility* blocks:

```python
import sbf_parser
    
with open('./dummy.sbf') as sbf_fobj:
 for blockName, block in sbfParser.load(sbf_fobj, blocknames={'SatVisibility'}):
  for satInfo in block['SatInfo']:
   print satInfo['SVID'], satInfo['Azimuth'], satInfo['Elevation']
```

