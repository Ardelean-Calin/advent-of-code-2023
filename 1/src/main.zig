const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./input.txt", .{});
    var bytes: [1024 * 12]u8 = undefined;
    var noBytes = try file.readAll(&bytes);

    // Stores the bytes of the current number
    var curNumBuf: [32]u8 = undefined;
    var maxSum: u32 = 0;
    var curSum: u32 = 0;
    var currIndex: u8 = 0;
    for (bytes[0..noBytes]) |byte| {
        // NL
        if (byte == 10) {
            if (currIndex == 0) {
                std.debug.print("Group break! Sum: {d}\n", .{curSum});
                curSum = 0;
                continue;
            }
            // Coersce bytes
            var curNum: u32 = try std.fmt.parseUnsigned(u32, curNumBuf[0..currIndex], 10);
            curSum += curNum;
            maxSum = @max(maxSum, curSum);

            currIndex = 0;
        } else {
            curNumBuf[currIndex] = byte;
            currIndex += 1;
        }
    }

    std.debug.print("Done! Maximum sum was: {d}\n", .{maxSum});
}
