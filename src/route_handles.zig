const std = @import("std");
const Request = @import("zap").Request;

pub fn home(r: Request) void {
    if (r.query) |query| std.debug.print("/ got: {s}\n", .{query});
    r.sendBody("<html><body>this is /</body></html>") catch return;
}

pub fn api_hello(r: Request) void {
    if (r.query) |query| std.debug.print("/api/hello got: {s}\n", .{query});
    r.sendBody("<html><body>this is /api/hello</body></html>") catch return;
}

pub fn serve_favicon(r: Request) void {
    r.sendBody(@embedFile("favicon.ico")) catch return;
}
