import ByteBuffer from 'bytebuffer'

@Entry
@Component
struct Writer_reader {
  @State readIString: string = "";

  private aboutToAppear() {

    var byteBuffer = new ByteBuffer()
      .writeIString("hello world")
      .flip();

    let logStr = "byteBuffer：" + byteBuffer.readIString() + "from bytebuffer.js"

    this.readIString = logStr;

    console.log(logStr);

  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("readIString：" + this.readIString)
        .fontSize(30)
        .fontWeight(FontWeight.Bold);
    }
    .width('100%')
    .height('100%')
  }
}