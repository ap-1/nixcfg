-- Window and workspace rules

-- Float TUI popups (termfilepickers and $mainMod + E pass --app-id)
hl.window_rule({ match = { class = "yazi" }, float = true })
hl.window_rule({ match = { class = "wiremix" }, float = true })
hl.window_rule({ match = { class = "impala" }, float = true })
hl.window_rule({ match = { class = "bluetui" }, float = true })

-- Always open Roblox in fullscreen
hl.window_rule({ match = { class = "^(org.vinegarhq.Sober)$" }, fullscreen = true })

-- Prevent Steam from stealing focus
hl.window_rule({ match = { class = "^[Ss]team" }, suppress_event = "activate" })

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
