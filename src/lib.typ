#import "@preview/pointless-size:0.1.2": zh, zihao

// 红色分隔线
#let red-separator() = {
  place(
    top + left,
    dx: 0pt,
    dy: -4mm,
    line(length: 100%, stroke: 1pt + red),
  )
}

// 版记分隔线
#let banji-separator(thick: false) = {
  line(length: 100%, stroke: if thick { 0.7pt } else { 0.35pt })
}

// 公文主体函数
#let gongwen(
  org: "", // 发文机关标志
  title: "", // 标题
  to: "", // 主送机关：字符串或数组
  fenhao: none, // 份号：6位3号阿拉伯数字
  miji: none, // 密级和保密期限：如"绝密★30年"
  jinji: none, // 紧急程度：如"特急"、"加急"
  fawenzihao: none, // 发文字号：如"国办发〔2025〕1号"
  qianfaren: none, // 签发人：字符串（单个）如"张三" 或 数组（多个）如("张三", "李四")
  fujian: none, // 附件说明：字符串或数组，如("附件：1. XXXXX", "附件：2. YYYYY")
  fawenjigou: "", // 发文机关署名：字符串或数组（联合行文）
  chengwenriqi: "", // 成文日期：字符串格式，如"2025年3月23日"
  fuzhu: none, // 附注
  chaosong: none, // 抄送机关：字符串或数组，如("各食堂", "各餐厅")
  yinfajiguan: "", // 印发机关
  yinfariqi: "", // 印发日期：字符串格式，如"2025年3月23日"
  body, // 正文内容
) = {
  // 页面设置：根据GB/T 9704—2012
  // 天头（上白边）为37mm±1mm，订口（左白边）为28mm±1mm
  set page(
    paper: "a4",
    margin: (top: 3.7cm - 0.35cm, bottom: 3.5cm, left: 2.8cm, right: 2.6cm),
  )

  show: it => {
    set page(
      footer: context {
        set text(size: zh(4), font: "FandolFang R")
        let page-num = counter(page).display()
        let page-int = int(page-num)
        if calc.rem(page-int, 2) == 0 {
          align(left)[— #page-num —]
        } else {
          align(right)[— #page-num —]
        }
      },
    )
    it
  }

  set text(
    font: ("Times New Roman", "FandolFang R"),
    size: zh(3),
  )
  set par(
    justify: true,
    leading: 1em,
    spacing: 0.5em,
  )

  // 将 none 转换为空字符串，方便后续统一判断
  if org == none { org = "" }
  if title == none { title = "" }
  if to == none { to = "" }
  if qianfaren == none { qianfaren = "" }
  if fujian == none { fujian = "" }
  if fawenjigou == none { fawenjigou = "" }
  if chengwenriqi == none { chengwenriqi = "" }
  if fuzhu == none { fuzhu = "" }
  if chaosong == none { chaosong = "" }
  if yinfajiguan == none { yinfajiguan = "" }
  if yinfariqi == none { yinfariqi = "" }
  if fenhao == none { fenhao = "" }
  if miji == none { miji = "" }
  if jinji == none { jinji = "" }

  // 过滤数组中的空字符串，如果只剩一个元素就转换为字符串
  if type(org) == array {
    org = org.filter(x => x != "")
    if org.len() == 1 { org = org.first() }
  }
  if type(to) == array {
    to = to.filter(x => x != "")
    if to.len() == 1 { to = to.first() }
  }
  if type(qianfaren) == array {
    qianfaren = qianfaren.filter(x => x != "")
    if qianfaren.len() == 1 { qianfaren = qianfaren.first() }
  }
  if type(fujian) == array {
    fujian = fujian.filter(x => x != "")
    if fujian.len() == 1 { fujian = fujian.first() }
  }
  if type(fawenjigou) == array {
    fawenjigou = fawenjigou.filter(x => x != "")
    if fawenjigou.len() == 1 { fawenjigou = fawenjigou.first() }
  }
  if type(chaosong) == array {
    chaosong = chaosong.filter(x => x != "")
    if chaosong.len() == 1 { chaosong = chaosong.first() }
  }

  // ===== 版头部分 =====

  // 份号、密级、紧急程度（左上角，浮动定位）
  if fenhao != "" or miji != "" or jinji != "" {
    place(
      top + left,
      dx: 0pt,
      dy: 0pt,
    )[
      #if fenhao != "" {
        align(left)[#text(size: zh(3), font: "FandolHei")[#fenhao]]
      } else {
        []
      }
      #if miji != "" {
        align(left)[#text(size: zh(3), font: "FandolHei")[#miji]]
      }
      #if jinji != "" {
        align(left)[#text(size: zh(3), font: "FandolHei")[#jinji]]
      }
    ]
  }

  // 发文机关标志（红色，居中，上边缘至版心上边缘为35mm）

  if org != "" {
    v(35mm)

    if type(org) == array {
      // 多个机关联合行文：机关垂直排列，"文件"在右边居中
      // 使用 context 计算最长的机关名称宽度，并实现分散对齐
      align(center)[
        #context {
          let widths = org.map(j => {
            measure(text(
              size: 55pt,
              font: ("Times New Roman", "Source Han Serif"),
              weight: "black",
            )[#j]).width
          })

          let max-width = if widths.len() == 0 { 0pt } else {
            calc.max(..widths)
          }

          grid(
            columns: (max-width, auto),
            gutter: 1em,
            stack(
              dir: ttb,
              spacing: 1em,
              ..org.map(j => block(
                width: max-width,
                align(right)[#text(
                  size: 55pt,
                  font: ("Times New Roman", "Source Han Serif"),
                  fill: red,
                  weight: "black",
                )[#j #linebreak(justify: true)]],
              )),
            ),
            align(horizon)[#align(left)[#text(
              size: 55pt,
              font: ("Times New Roman", "Source Han Serif"),
              fill: red,
              weight: "black",
            )[文件]]],
          )
        }
      ]
    } else {
      // 单个机关
      align(center)[
        #text(size: 55pt, font: ("Times New Roman", "Source Han Serif"), fill: red, weight: "black")[#org\文件]
      ]
    }
  }

  // 发文字号和签发人


  if fawenzihao != "" or qianfaren != "" {
    v(1.67cm) // 下空二行位置
    if qianfaren != "" {
      grid(
        columns: (1fr, 1fr),
        gutter: 0pt,
        if fawenzihao != "" {
          align(left)[#text(size: zh(3))[#fawenzihao]]
        } else {
          []
        },
        if qianfaren != "" {
          align(right)[
            #text(size: zh(3))[签发人：]
            #if type(qianfaren) == array { qianfaren.join("、") } else { qianfaren }
          ]
        } else {
          []
        },
      )
    } else {
      // 没有签发人，发文字号居中
      if fawenzihao != "" {
        align(center)[#text(size: zh(3))[#fawenzihao]]
      }
    }
  }
  // 版头中的红色分隔线（只要版头有任何一个元素就显示）
  if org != "" or fawenzihao != "" or qianfaren != "" {
    v(4mm)
    line(length: 100%, stroke: 1pt + red)
    v(1em)
  }


  // ===== 主体部分 =====

  // 标题（红色分隔线下空二行位置）
  if title != "" {
    [#align(center)[
      #text(size: zh(2), font: ("Times New Roman", "Source Han Serif"), weight: "black")[#title]
    ]]
  }

  // 主送机关（标题下空一行位置，居左顶格）

  if to != "" {
    v(1em)
    [#align(left)[
      #if type(to) == array {
        [#to.join("，")：]
      } else {
        [#to：]
      }
    ]]
  }

  // 正文（3号仿宋体，每个自然段左空二字，回行顶格）
  set par(
    leading: 1em,
    first-line-indent: (amount: 2em, all: true),
  )

  body

  set par(
    first-line-indent: (amount: 0em, all: true),
  )

  // 附件说明
  if fujian != "" {
    v(1em)
    if type(fujian) == array {
      // 多个附件，每个单独一行
      for f in fujian {
        align(left)[#h(2em)#text(size: zh(3))[#f]]
      }
    } else {
      // 单个附件
      align(left)[#h(2em)#text(size: zh(3))[#fujian]]
    }
  }

  // 发文机关署名、成文日期和印章
  if fawenjigou != "" or chengwenriqi != "" {
    v(1em)

    // 发文机关署名居中
    if fawenjigou != "" {
      if type(fawenjigou) == array {
        // 联合行文，多个机关依次向下编排
        for j in fawenjigou {
          align(center)[#j]
        }
      } else {
        // 单个机关
        align(right)[#fawenjigou]
      }
    }

    // 成文日期右空四字
    if chengwenriqi != "" {
      align(right)[#text(size: zh(3))[#chengwenriqi]]
    }
  }

  // 附注
  if fuzhu != "" {
    v(1em)
    align(left)[#par(first-line-indent: (amount: 2em, all: true))[#text(size: zh(3))[（#fuzhu）]]]
  }

  // ===== 版记部分 =====

  // 版记分隔线和内容
  align(bottom)[
    #v(1em)

    #if chaosong != "" or yinfajiguan != "" or yinfariqi != "" {
      // 首条分隔线（粗线）
      banji-separator(thick: true)

      // 抄送机关
      if chaosong != "" {
        [#text(size: zh(4))[#align(left)[
          #h(1em)抄送：
          #if type(chaosong) == array { chaosong.join("、") } else { chaosong }
          。
        ]]]

        // 中间分隔线（细线）
        banji-separator(thick: false)
      }

      // 印发机关和印发日期

      grid(
        columns: (1fr, 1fr),
        gutter: 0pt,
        if yinfajiguan != "" {
          align(left)[#text(size: zh(4))[#h(1em)#yinfajiguan]]
        } else {
          []
        },
        if yinfariqi != "" {
          align(right)[#text(size: zh(4))[#yinfariqi\印发#h(1em)]]
        } else {
          []
        },
      )
      // 末条分隔线（粗线）
      banji-separator(thick: true)
    }
  ]
}
