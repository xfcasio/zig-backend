const std = @import("std");
const Request = @import("zap").Request;

pub fn home(r: Request) void {
    if (r.query) |query| std.debug.print("/ got: {s}\n", .{query});
    r.sendBody("<html><body>this is /</body></html>") catch |e| {
        std.debug.print("[ERROR] {}", .{e});
        r.setStatus(.internal_server_error);
    };
}

pub fn apiHello(r: Request) void {
    if (r.query) |query| std.debug.print("/api/hello got: {s}\n", .{query});
    r.sendBody("<html><body>this is /api/hello</body></html>") catch |e| {
        std.debug.print("[ERROR] {}", .{e});
        r.setStatus(.internal_server_error);
    };
}

pub fn serveFavicon(r: Request) void {
    r.sendBody(@embedFile("assets/favicon.ico")) catch |e| {
        std.debug.print("[ERROR] {}", .{e});
        r.setStatus(.internal_server_error);
    };
}

pub fn pageNotFound(r: Request) void {
    r.setStatus(.not_found);
    r.sendBody(
        \\ <html>
        \\  <h1 style="text-align: center; margin-top: 200;">Page not found</h1>
        \\  <a href="/"
        \\      style="
        \\          display:block;
        \\          margin-right: 600;
        \\          margin-left: 600;
        \\          padding:10px 20px;
        \\          background-color:#007bff;
        \\          color:white;
        \\          text-decoration:none;
        \\          text-align:center;
        \\          border-radius:5px;
        \\      "
        \\  >
        \\    Go back to home
        \\  </a>
        \\ </html>
    ) catch |e| {
        std.debug.print("[ERROR] {}", .{e});
    };
}
