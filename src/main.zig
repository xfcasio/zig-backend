const std = @import("std");
const zap = @import("zap");
const route_handles = @import("route_handles.zig");

const routes = std.StaticStringMap(*const fn (zap.Request) void).initComptime(.{
    .{ "/"           , route_handles.home          },
    .{ "/api/hello"  , route_handles.api_hello     },
    .{ "/favicon.ico", route_handles.serve_favicon },
});

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 8080,
        .on_request = request_handler,
        .log = true,
        .max_clients = 100000,
    });
    
    listener.listen() catch |err| {
        std.debug.print("{}: Error setting up listener on port 80, check privilages", .{err});
        return;
    };

    std.debug.print("Listening on 0.0.0.0:3000\n", .{});

    zap.start(.{ .threads = 2, .workers = 2 });
}

fn request_handler(r: zap.Request) void {
    if (r.path) |path|
        if (routes.get(path)) |route| route(r);
}
