const std = @import("std");
const zap = @import("zap");
const route_handles = @import("route_handles.zig");

const routes: std.StaticStringMap(*const fn (zap.Request) void) = .initComptime(.{
    .{ "/"           , route_handles.home          },
    .{ "/api/hello"  , route_handles.apiHello      },
    .{ "/favicon.ico", route_handles.serveFavicon  },
});

pub fn main() !void {
    var listener: zap.HttpListener = .init(.{
        .port = 8080,
        .on_request = requestHandler,
        .log = true,
        .max_clients = 100000,
    });
    
    listener.listen() catch |err| {
        std.debug.print("{}: Error setting up listener on port 8080", .{err});
        return;
    };

    std.debug.print("Listening on 0.0.0.0:8080\n", .{});

    zap.startWithLogging(.{ .threads = 2, .workers = 2 });
}

fn requestHandler(r: zap.Request) void {
    if (r.path) |path|
        if (routes.get(path)) |route| route(r);
}
