/*
数据元发送者content模型实体,支持自定义拓展字段
 */
// 角色枚举类型
import 'dart:io';

import '../../common/tools.dart';

enum AttachmentType {
  pdf, // PDF 文档
  doc, // DOC 文档
  docx, // DOCX 文档
  txt, // 纯文本文件
  rtf, // RTF 文档
  xls, // XLS 电子表格
  xlsx, // XLSX 电子表格
  csv, // CSV 文件
  ppt, // PPT 演示文稿
  pptx, // PPTX 演示文稿
  odp, // ODP 演示文稿
  jpg, // JPG 图像
  jpeg, // JPEG 图像
  png, // PNG 图像
  gif, // GIF 图像
  bmp, // BMP 图像
  mp3, // MP3 音频
  wav, // WAV 音频
  aac, // AAC 音频
  mp4, // MP4 视频
  avi, // AVI 视频
  mov, // MOV 视频
  zip, // ZIP 压缩包
  rar, // RAR 压缩包
  z7, // 7Z 压缩包
  exe, // EXE 可执行文件
  app, // APP 应用程序文件
  bat, // BAT 批处理文件
  html, // HTML 文件
  css, // CSS 文件
  js, // JS 文件
  py, // PY 文件
  java, // JAVA 文件
  c, // C 文件
  cpp // C++ 文件
}

Map<AttachmentType, String> attachmentTypeToString = {
  AttachmentType.pdf: "pdf",
  AttachmentType.doc: "doc",
  AttachmentType.docx: "docx",
  AttachmentType.txt: "txt",
  AttachmentType.rtf: "rtf",
  AttachmentType.xls: "xls",
  AttachmentType.xlsx: "xlsx",
  AttachmentType.csv: "csv",
  AttachmentType.ppt: "ppt",
  AttachmentType.pptx: "pptx",
  AttachmentType.odp: "odp",
  AttachmentType.jpg: "jpg",
  AttachmentType.jpeg: "jpeg",
  AttachmentType.png: "png",
  AttachmentType.gif: "gif",
  AttachmentType.bmp: "bmp",
  AttachmentType.mp3: "mp3",
  AttachmentType.wav: "wav",
  AttachmentType.aac: "aac",
  AttachmentType.mp4: "mp4",
  AttachmentType.avi: "avi",
  AttachmentType.mov: "mov",
  AttachmentType.zip: "zip",
  AttachmentType.rar: "rar",
  AttachmentType.z7: "7z",
  AttachmentType.exe: "exe",
  AttachmentType.app: "app",
  AttachmentType.bat: "bat",
  AttachmentType.html: "html",
  AttachmentType.css: "css",
  AttachmentType.js: "js",
  AttachmentType.py: "py",
  AttachmentType.java: "java",
  AttachmentType.c: "c",
  AttachmentType.cpp: "cpp"
};

Map<String, AttachmentType> stringToAttachmentType = {
  "pdf": AttachmentType.pdf,
  "doc": AttachmentType.doc,
  "docx": AttachmentType.docx,
  "txt": AttachmentType.txt,
  "rtf": AttachmentType.rtf,
  "xls": AttachmentType.xls,
  "xlsx": AttachmentType.xlsx,
  "csv": AttachmentType.csv,
  "ppt": AttachmentType.ppt,
  "pptx": AttachmentType.pptx,
  "odp": AttachmentType.odp,
  "jpg": AttachmentType.jpg,
  "jpeg": AttachmentType.jpeg,
  "png": AttachmentType.png,
  "gif": AttachmentType.gif,
  "bmp": AttachmentType.bmp,
  "mp3": AttachmentType.mp3,
  "wav": AttachmentType.wav,
  "aac": AttachmentType.aac,
  "mp4": AttachmentType.mp4,
  "avi": AttachmentType.avi,
  "mov": AttachmentType.mov,
  "zip": AttachmentType.zip,
  "rar": AttachmentType.rar,
  "7z": AttachmentType.z7,
  "exe": AttachmentType.exe,
  "app": AttachmentType.app,
  "bat": AttachmentType.bat,
  "html": AttachmentType.html,
  "css": AttachmentType.css,
  "js": AttachmentType.js,
  "py": AttachmentType.py,
  "java": AttachmentType.java,
  "c": AttachmentType.c,
  "cpp": AttachmentType.cpp
};

class AttachmentMetaModel with CommonTool {
  // 文件类型
  AttachmentType? type;
  // 附件链接
  String? url;
  //附件名
  String? name;

  // 通过自动代码生成添加字段:在编译之前运行

  // toJson
  Map toJson() {
    Map jsonMap = {
      "type": attachmentTypeToString[type].toString(), // 文件类型
      "url": url.toString(), // 附件链接
      "name": name //附件名
      // 自定义插入字段插入位置:不能删掉下行的注释，他作为插入位置
      //@addFiledToJson@//
    };
    return jsonMap;
  }
}
