const std = @import("std");
const Request = @import("zap").Request;

pub fn home(r: Request) void {
    if (r.query) |query| std.debug.print("/ got: {s}\n", .{query});
    r.sendBody("<html><body>this is /</body></html>") catch return;
}

pub fn apiHello(r: Request) void {
    if (r.query) |query| std.debug.print("/api/hello got: {s}\n", .{query});
    r.sendBody("<html><body>this is /api/hello</body></html>") catch return;
}

pub fn serveFavicon(r: Request) void {
    r.sendBody(@embedFile("assets/favicon.ico")) catch return;
}
