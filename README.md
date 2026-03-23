# Gongwen

[简体中文](README-zh.md) | English

Gongwen (公文) is a Typst package for creating Chinese official documents with proper formatting according to GB/T 9704—2012 national standard.

## Features

- **Standard compliance**: Follows GB/T 9704—2012 formatting requirements
- **Complete document structure**: Supports 版头 (header), 主体 (body), and 版记 (footer) sections
- **Joint documents**: Supports multi-organization documents with proper formatting
- **Automatic pagination**: Alternating page number positions (odd/even pages)
- **Flexible parameters**: All fields optional, with sensible defaults

## Installation

Add to your Typst project:

```typst
#import "@local/gongwen:0.1.0": gongwen
```

Or use locally:

```typst
#import "src/lib.typ": gongwen
```

## Quick Start

```typst
#import "@local/gongwen:0.1.0": gongwen

#show: gongwen.with(
  org: "Example Organization",
  title: "Document Title",
  to: "Recipients",
  fawenzihao: "Example发〔2026〕1号",
  fawenjigou: "Example Organization",
  chengwenriqi: "2026年3月24日",
)

This is the document body content with proper formatting.
```

## Parameters

### Header Section (版头)
| Parameter | Type | Description |
|-----------|------|-------------|
| `fenhao` | string | 份号 (6-digit number) |
| `miji` | string | 密级 (e.g., "绝密★30年") |
| `jinji` | string | 紧急程度 (e.g., "特急") |
| `org` | string/array | 发文机关标志 |
| `fawenzihao` | string | 发文字号 |
| `qianfaren` | string/array | 签发人 |

### Body Section (主体)
| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | string | 标题 |
| `to` | string/array | 主送机关 |
| `body` | content | 正文 |
| `fujian` | string/array | 附件说明 |
| `fawenjigou` | string/array | 发文机关署名 |
| `chengwenriqi` | string | 成文日期 |
| `fuzhu` | string | 附注 |

### Footer Section (版记)
| Parameter | Type | Description |
|-----------|------|-------------|
| `chaosong` | string/array | 抄送机关 |
| `yinfajiguan` | string | 印发机关 |
| `yinfariqi` | string | 印发日期 |

## Font Requirements

The package requires the following fonts:
- **Times New Roman** + **Source Han Serif** - Organization names and titles (red)
- **FandolFang R** - Body text
- **FandolHei** - 份号/密级/紧急程度

## License

MIT License - see [LICENSE](LICENSE) for details.
