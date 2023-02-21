
# Example Plugin

This is a example plugin which will demonstrate some of CubeCat's abilities.
CubeCat Example Plugin is created to demonstrate the following:

- [x] Services
	> CubeCat should properly create, Init and make services available.
	> Services should handle all logic, computing and storage of state to make
	> sure that your plugin can be extendable by any extension plugin.
- [x] Components
	> Display that UI components all work and function as they are supposed to
	> and make sure that they are properly managed and created.
- [x] CubeCat Utilities
	> CubeCat comes with certain UI utilities and objects like `Runtime`, `Export` and `Import`. These are all tested and ensured that they properly
	> work.
- [ ] Permissions
	> CubeCat is designed to be a framework that works with multiple plugins
	> allowing other developers to write extension plugins to increase the
	> functionality of the main plugin.
	>
	> Permissions should be the solution to making sure this all remains secure
	> and prevent malicious actors from abusing this feature.
- [ ] Hot Reloading
	> Extension Plugins are incredibly powerful, but fall short when CubeCat is
	> being reload on the plugin it is supposed to extend, or itself is being
	> reloaded, in which case we need to clear all state of said plugin.
	>
	> Extension Plugins have dedicated `:Cleanup` calls on Services to allow
	> them to cleanup before being destroyed.