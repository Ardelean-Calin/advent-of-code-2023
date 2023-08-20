const std = @import("std");

fn cmpByValue(context: void, a: u32, b: u32) bool {
    return std.sort.asc(u32)(context, a, b);
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./input.txt", .{});
    var bytes: [1024 * 12]u8 = undefined;
    var noBytes = try file.readAll(&bytes);
    var sumArray: [300]u32 = undefined;

    // Stores the bytes of the current number
    var curNumBuf: [32]u8 = undefined;
    var maxSum: u32 = 0;
    var curSum: u32 = 0;
    var currIndex: u8 = 0;
    var sumIndex: usize = 0;

    for (bytes[0..noBytes]) |byte| {
        // NL
        if (byte == 10) {
            if (currIndex == 0) {
                std.debug.print("Group break! Sum: {d}\n", .{curSum});
                sumArray[sumIndex] = curSum;
                sumIndex += 1;
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

    std.sort.sort(u32, sumArray[0..sumIndex], {}, cmpByValue);

    var topThree: u32 = 0;
    for (sumArray[sumIndex - 3 .. sumIndex]) |v| {
        topThree += v;
    }
    std.debug.print("Done! Sum array: {any}\tSize:{d}\nTop-three: {d}\n", .{ sumArray[0..sumIndex], sumIndex, topThree });
}
