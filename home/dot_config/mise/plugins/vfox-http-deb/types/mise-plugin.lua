--- LuaCATS type definitions for mise backend plugins.
--- Based on https://github.com/jdx/mise-backend-plugin-template.

---@class Runtime
---@field osType string
---@field archType string
---@field version string
---@field pluginDirPath string
RUNTIME = {}

---@class SystemDependencyPackages
---@field pacman? string
---@field apt? string
---@field dnf? string
---@field apk? string
---@field brew? string

---@class SystemDependency
---@field bin? string
---@field version? string
---@field packages? SystemDependencyPackages

---@class Plugin
---@field name string
---@field version string
---@field description string
---@field author string
---@field homepage? string
---@field license? string
---@field minRuntimeVersion? string
---@field notes? string[]
---@field depends? string[]
---@field systemDependencies? SystemDependency[]
---@field BackendListVersions? fun(self: Plugin, ctx: BackendListVersionsCtx): BackendListVersionsResult
---@field BackendInstall? fun(self: Plugin, ctx: BackendInstallCtx): BackendInstallResult
---@field BackendExecEnv? fun(self: Plugin, ctx: BackendExecEnvCtx): BackendExecEnvResult
PLUGIN = {}

---@class HttpDebPlatformOptions
---@field url string
---@field checksum string

---@class HttpDebOptions
---@field bin_path string
---@field version_list_url string
---@field version_json_path string
---@field platforms table<string, HttpDebPlatformOptions>

---@class BackendListVersionsCtx
---@field tool string
---@field options HttpDebOptions

---@class BackendListVersionsResult
---@field versions string[]

---@class BackendInstallCtx
---@field tool string
---@field version string
---@field install_path string
---@field download_path string
---@field options HttpDebOptions

---@class BackendInstallResult

---@class EnvKey
---@field key string
---@field value string

---@class BackendExecEnvCtx
---@field tool string
---@field version string
---@field install_path string
---@field options HttpDebOptions

---@class BackendExecEnvResult
---@field env_vars EnvKey[]

---@class HttpRequestOptions
---@field url string
---@field headers? table<string, string>

---@class HttpResponse
---@field status_code integer
---@field headers table<string, string>
---@field body string

---@class http
---@field get fun(options: HttpRequestOptions): HttpResponse
---@field download_file fun(options: HttpRequestOptions, path: string)

---@class CmdExecOptions
---@field cwd? string
---@field env? table<string, string>
---@field timeout? integer

---@class cmd
---@field exec fun(command: string, options?: CmdExecOptions): string

---@class file
---@field exists fun(path: string): boolean
---@field glob fun(pattern: string): string[]
---@field join_path fun(...: string): string

---@class json
---@field decode fun(value: string): any

---@class semver
---@field sort fun(versions: string[]): string[]

return nil
