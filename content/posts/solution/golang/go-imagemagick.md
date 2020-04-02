---
title : Go+ImageMagick使用svg+png绘制复杂图片
description : Go+ImageMagick使用svg+png绘制复杂图片
tags:
 - golang
 - imagemagick
date: 2018-06-01
categories:
 - "solution"
weight: 1

---

## 需求 <audio preload="none"></audio> 

开发过程会有使用go绘制较为复杂图形的需求，比如这次，需要做一个类似拖拽图案验证码。
具体需求：

1. 4条边,凹凸平3个形状，随机组合，
2. 随机位置上截图如上形状的图片，并且在原图有如上形状的阴影遮罩

go自带`image/draw` package 不能绘制复杂的图形（或者说太复杂），经过尝试，可以使用go来绘制svg，再使用imagemagick来进行特效处理，最后再次使用go把图层融合在一起。


<!--more-->
##### 涉及package

`github.com/ajstarks/svgo`  #基本图形svg绘制  
`github.com/gographics/imagick` #特效处理（需安装imagemagick)



### 先上最终最终效果
![origin.png](/image/go/gm1.png)

![tile-final.png](/image/go/gm2.png)

## 步骤
### 一、go 绘制基本图形

使用 svgo 来绘制 path，生成 svg，代码贴在最后

### 二、imagemagick convert把 svg 转化为 png, 加阴影
注：只展示 imagemagick convert，没有融合到 go 程序里

![tile.png](/image/go/gm3.png)

```shell
# ImageMagick convert 命令
convert \
  \( -background none MSVG:tile-cut.svg -background black -shadow 50x2+0+10 \
    -gravity North -background none -extent 200x200 \
    -compose over  \
    \( -background none MSVG:tile-cut.svg -background white -shadow 120x6+0+0 -resize 95% \
      -gravity center -background none -extent 200x200 \
    \) \
    -background none -gravity NorthEast -geometry +0+0 -composite \
  \) \
  -compose over tile-line.svg -gravity center -geometry +0+0 -composite \
tile.png
```
代码注释：

1. MSVG 支持svg 作为输入源，需要 imagemagick 支持 rsvg， 比如mac：
```brew install imagemagick --with-librsvg ```
2. ```-background black -shadow 50x2+0+10``` 前两个数字自己调着看，影响shadow的大小和透明度，后两个是x，y轴偏移，可+可-
3. ```-background none``` 背景透明
4. compose 两个图层组合方式， over 表示 后者在前者之上，还有其他选项，详见官网手册
5. ```-gravity North -background none -extent 200x200``` -extent 扩展图片尺寸，-gravity North 表示扩展的时候，原图处于什么位置，North 表示北，还有NorthEast 等，详见官网手册


### 三、处理阴影svg
![tile-shadow.png](/image/go/gm4.png)

```shell
# ImageMagick convert 命令
convert -density 2400 -background transparent  MSVG:tile-shadow.svg \
-fill "rgba(0,0,0,0.3)" -opaque black -resize 200x200 tile-shadow.png
```
代码注释：

1. -opaque 删除图片中颜色，这里删除黑色，填充rgba(0,0,0,0.3), 否则不能转化透明度，这里用了一个trick
2. -density 2400 这里通过修改了分辨率来提高 svg 转化到 png 的细致程度，再强制 -resize 200x200

完成这个小需求绕挺多弯路现总结如下：

1. go 可以完成一些简单图形的绘制，比如shape/tile 中At方法其实是对每个点进行上色，这是 draw 包的实现
2. go 支持图层叠加，支持图层融合
3. 绘制几何图形使用 svg path，很方便，go可以使用 svgo 包，但是不支持转化成png图片，也不能作为draw包的输入源
4. 图片处理 使用 imagemagick, 我这里没有使用扩展把逻辑写到代码里，因为我可以把这些 tile png先生成，go直接叠加图层，降低运算，比如这次需求，4条边，3种形状(凹凸平),2个类型(外边阴影，阴影填充) ，3x3x3x3x2 = 162


## 附go代码：

{{< tabs "go-image" >}}

{{< tab "main.go" >}}
main.go
```go
package main

import (
	"image"
	"log"
	_ "image/jpeg"
	_ "image/png"
	"os"
	"math/rand"
	"time"
	"math"
	"image/png"
	"image/draw"
	"captcha/shape"
)

func main() {

    //保存svgs，
    saveSvgs()

	cutWidth := 200
	top, right, bottom, left := 1, 1, 0, -1
   
	reader, err := os.Open("images/14d4c647b216975cb298481f4e550ebc.jpg")
	if err != nil {
		log.Fatal(err)
	}
	defer reader.Close()
	m, _, err := image.Decode(reader)
	rgbImg := m.(*image.YCbCr)

	reader2, err := os.Open("tile.png")
	if err != nil {
		log.Fatal(err)
	}
	defer reader2.Close()
	m2, _, err := image.Decode(reader2)
	rgbImg2 := m2.(*image.NRGBA64)

	reader3, err := os.Open("tile-shadow.png")
	if err != nil {
		log.Fatal(err)
	}
	defer reader3.Close()
	m3, _, err := image.Decode(reader3)
	rgbImg3 := m3.(*image.NRGBA64)

	randRect := getRandomRectangle(m.Bounds(), cutWidth, cutWidth)
	tile := shape.Tile{image.Pt(45, 0), cutWidth, top, right, bottom, left, false}

    // go draw 包处理代码，
    // 新建图片
	originImage := image.NewRGBA(rgbImg.Bounds())
    // 使用draw原图
	draw.Draw(originImage, rgbImg.Bounds(), rgbImg, rgbImg.Bounds().Min, draw.Src)
	// 把imagemagick处理好的阴影png 绘制到图片的随机位置 randRect 之上
	draw.Draw(originImage, randRect.Bounds(), rgbImg3, rgbImg3.Bounds().Min, draw.Over)

	f2, _ := os.Create("origin.png")
	defer f2.Close()
	png.Encode(f2, originImage)

	cutImage4 := image.NewRGBA(image.Rect(0, 0, cutWidth, cutWidth))
	// 在随机位置randRect 截取 tile 形状的截图
    draw.DrawMask(cutImage4, cutImage4.Bounds(), rgbImg, randRect.Bounds().Min, &tile, tile.Bounds().Min, draw.Src)
    // 在图片之上添加 imagemagick 处理好的 tile.png
	draw.Draw(cutImage4, cutImage4.Bounds(), rgbImg2, rgbImg2.Bounds().Min, draw.Over)
	f5, _ := os.Create("tile-final.png")
	defer f5.Close()
	png.Encode(f5, cutImage4)
}

// 绘制svg
func saveSvgs(){
    cutWidth := 200
	top, right, bottom, left := 1, 1, 0, -1

    //保存 svg 文件
	tileSvg := shape.TileSvg{cutWidth, top, right, bottom, left}
	tileSvg.SaveSvg("tile-cut.svg", "stroke-width:10;stroke:White;fill:none;")
	tileSvg.SaveSvg("tile-line.svg", "stroke-width:2;stroke:White;fill:none;")
	tileSvg.SaveSvg("tile-shadow.svg", "stroke-width:2;stroke:White;fill:black;fill-opacity:0.5")
}

// 随机获取截图位置
func getRandomRectangle(rectangle image.Rectangle, subWidth int, subHeight int) (*image.Rectangle) {
	bounds := rectangle.Bounds()
	width := bounds.Max.X - bounds.Min.X
	height := bounds.Max.Y - bounds.Min.Y

	rand.Seed(time.Now().Unix())
	maxPosX := math.Ceil(float64(width)*0.7) - math.Ceil(float64(subWidth)*1.3)
	maxPosY := math.Ceil(float64(height)*0.7) - math.Ceil(float64(subHeight)*1.3)
	if maxPosX < 0 || maxPosY < 0 {
		//todo error
		tmp := image.Rect(0, 0, 0, 0)
		return &tmp
	}
	posX := rand.Intn(int(maxPosX)) + int(math.Ceil(float64(width)*0.3))
	posY := rand.Intn(int(maxPosY)) + int(math.Ceil(float64(height)*0.3))

	log.Println(maxPosX, maxPosY)
	log.Println(posX, posY, posX+int(subWidth), posY+int(subHeight))

	retRectangle := image.Rect(posX, posY, posX+int(subWidth), posY+int(subHeight), )

	return &retRectangle
}
```

{{< /tab >}}
{{< tab "shape/tilesvg.go" >}} 

绘制svg图形
```go
package shape

import (
	"os"
	"fmt"
	"github.com/ajstarks/svgo"
)

type TileSvg struct {
	Width int
	T     int
	R     int
	B     int
	L     int
}

/**
shape svg path
 */
func (t *TileSvg) SaveSvg(filename string, stroke string) {
	width := t.Width
	height := t.Width
	f5, _ := os.Create(filename)
	canvas := svg.New(f5)
	canvas.Start(width, height)

	if len(stroke) <= 0 {
		stroke = "stroke-width:10;stroke:green;fill:red;"
	}
	path := fmt.Sprintf("M%d,%d h%d ", width/5, width/5, width/5)

	if t.T > 0 {
		path += fmt.Sprintf("A%d,%d 0 0,1 %d,%d ", width/10, width/10, width*3/5, width/5)
	} else if t.T < 0 {
		path += fmt.Sprintf("A%d,%d 0 1,0 %d,%d ", width/10, width/10, width*3/5, width/5)
	} else {
		path += fmt.Sprintf("h+%d ", width/5)
	}
	path += fmt.Sprintf("h%d v%d ", width/5, width/5)
	if t.R > 0 {
		path += fmt.Sprintf("A%d,%d 0 0,1 %d,%d ", width/10, width/10, width*4/5, width*3/5)
	} else if t.R < 0 {
		path += fmt.Sprintf("A%d,%d 0 1,0 %d,%d ", width/10, width/10, width*4/5, width*3/5)
	} else {
		path += fmt.Sprintf("v+%d ", width/5)
	}
	path += fmt.Sprintf("v%d h-%d ", width/5, width/5)

	if t.B > 0 {
		path += fmt.Sprintf("A%d,%d 0 0,1 %d,%d ", width/10, width/10, width*2/5, width*4/5)
	} else if t.B < 0 {
		path += fmt.Sprintf("A%d,%d 0 1,0 %d,%d ", width/10, width/10, width*2/5, width*4/5)
	} else {
		path += fmt.Sprintf("h-%d ", width/5)
	}
	path += fmt.Sprintf("h-%d v-%d ", width/5, width/5)

	if t.L > 0 {
		path += fmt.Sprintf(" A%d,%d 0 0,1 %d,%d ", width/10, width/10, width/5, width*2/5)
	} else if t.L < 0 {
		path += fmt.Sprintf(" A%d,%d 0 1,0 %d,%d ", width/10, width/10, width/5, width*2/5)
	} else {
		path += fmt.Sprintf("v-%d ", width/5)
	}
	path += fmt.Sprintf("v-%d ", width/5)
	canvas.Path(path, stroke)

	canvas.End()
}

```

{{< /tab >}}

{{< tab "shape/tile.go" >}}
shape/tile.go
```go
package shape

import (
	"image"
	"image/color"
)

type Tile struct {
	Min    image.Point
	Width  int
	T      int
	R      int
	B      int
	L      int
	Revert bool
}

func (c *Tile) ColorModel() color.Model {
	return color.AlphaModel
}

func (c *Tile) Bounds() image.Rectangle {
	return image.Rect(c.Min.X, c.Min.Y, c.Min.X+c.Width, c.Min.Y+c.Width)
}

func (c *Tile) At(x, y int) color.Color {

	colorAt := color.Alpha{220}
	colorWithin := color.Alpha{220}
	colorWithout := color.Alpha{0}
	if c.Revert {
		colorWithin = color.Alpha{0}
		colorWithout = color.Alpha{220}
	}

	margin := c.Width / 5
	if x > (c.Min.X+c.Width/5) && x < (c.Bounds().Max.X-c.Width/5) && y > (c.Min.Y+c.Width/5) && y < (c.Bounds().Max.Y-c.Width/5) {
		colorAt = colorWithin
	} else {
		colorAt = colorWithout
	}

	r := c.Width / 10
	//todo 优化算法

	if c.T != 0 {
		roundSpot := image.Pt((c.Bounds().Max.X-c.Min.X)/2+c.Min.X, c.Min.Y+margin)
		xx, yy, rr := float64(x-roundSpot.X)+0.5, float64(y-roundSpot.Y)+0.5, float64(r)+0.5
		if xx*xx+yy*yy < rr*rr {
			if c.T > 0 {
				colorAt = colorWithin
			} else {
				colorAt = colorWithout
			}
		}
	}

	if c.R != 0 {
		roundSpot := image.Pt(c.Bounds().Max.X-margin, (c.Bounds().Max.Y-c.Min.Y)/2+c.Min.Y)
		xx, yy, rr := float64(x-roundSpot.X)+0.5, float64(y-roundSpot.Y)+0.5, float64(r)+0.5
		if xx*xx+yy*yy < rr*rr {
			if c.R > 0 {
				colorAt = colorWithin
			} else {
				colorAt = colorWithout
			}
		}
	}

	if c.B != 0 {
		roundSpot := image.Pt((c.Bounds().Max.X-c.Min.X)/2+c.Min.X, (c.Bounds().Max.Y - margin))
		xx, yy, rr := float64(x-roundSpot.X)+0.5, float64(y-roundSpot.Y)+0.5, float64(r)+0.5
		if xx*xx+yy*yy < rr*rr {
			if c.B > 0 {
				colorAt = colorWithin
			} else {
				colorAt = colorWithout
			}
		}
	}

	if c.L != 0 {
		roundSpot := image.Pt(c.Min.X+margin, (c.Bounds().Max.Y-c.Min.Y)/2+c.Min.Y)
		xx, yy, rr := float64(x-roundSpot.X)+0.5, float64(y-roundSpot.Y)+0.5, float64(r)+0.5
		if xx*xx+yy*yy < rr*rr {
			if c.L > 0 {
				colorAt = colorWithin
			} else {
				colorAt = colorWithout
			}
		}
	}

	return colorAt
}

```
{{< /tab >}}

{{< /tabs >}}
