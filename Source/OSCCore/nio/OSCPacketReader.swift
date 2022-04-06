//
//  OSCPacketReader.swift
//  OSCCore
//
//  Created by Sebestyén Gábor on 2018. 06. 06..
//

import NIO


public final class OSCPacketReader: ChannelInboundHandler {
    public typealias InboundIn = AddressedEnvelope<ByteBuffer>
    public typealias InboundOut = OSCConvertible

    public init() {}

    public func channelActive(context: ChannelHandlerContext) {
       // print("Client connected to \(context.remoteAddress!)")
//        if let ra = context.remoteAddress {
//            print("Client connected to \(ra)")
//        } else {
//            print("Client connected to NIL!!!")
//        }
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
//        print( "in channel read\n")
        let addressedEnvelope = self.unwrapInboundIn(data)

        if let rawBytes: [Byte] = addressedEnvelope.data.getBytes(at: 0, length: addressedEnvelope.data.readableBytes),
            let packet = decodeOSCPacket(from: rawBytes) {
            context.fireChannelRead(self.wrapInboundOut(packet))
        }
    }

    public func channelReadComplete(context: ChannelHandlerContext) {
//        print( "in channel complete\n")
        context.flush()
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
//        print( "in channel error:   \(error)\n")
        context.close(promise: nil)
    }
}
