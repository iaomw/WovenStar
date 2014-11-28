WovenStar
=========

iOS port of [Woven star](https://dribbble.com/shots/1691328-Woven-star).

<img src="WovenStar.gif"/>

## Installation

Add the `WovenStar.h` and `WovenStar.m` source files to your project.

## Usage

``` objective-c

WovenStar *ws = [[WovenStar alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
[ws setForeColor:[UIColor colorWithRed:164.0/255 green:194.0/255 blue:231.0/255 alpha:1]
    andBackColor:[UIColor colorWithRed:44.0/255 green:72.0/255 blue:108.0/255 alpha:1]];

[ws setCenter:self.view.center];

[self.view addSubview:ws];

```

## License

[MIT license](LICENSE.md). 