local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
	s(
		{ trig = "h1", name = "Header 1", desc = "Add header level 1" },
		{ t("# "), i(0) }
	),
	s(
		{ trig = "h2", name = "Header 2", desc = "Add header level 2" },
		{ t("## "), i(0) }
	),
	s(
		{ trig = "h3", name = "Header 3", desc = "Add header level 3" },
		{ t("### "), i(0) }
	),
	s(
		{ trig = "h4", name = "Header 4", desc = "Add header level 4" },
		{ t("#### "), i(0) }
	),
	s(
		{ trig = "h5", name = "Header 5", desc = "Add header level 5" },
		{ t("##### "), i(0) }
	),
	s(
		{ trig = "h6", name = "Header 6", desc = "Add header level 6" },
		{ t("###### "), i(0) }
	),
	s({ trig = "l", name = "Links", desc = "Add links" }, {
		t("["),
		i(1, "text"),
		t("]("),
		i(2, "url"),
		t(") "),
		i(0),
	}),
	s(
		{ trig = "u", name = "URLS", desc = "Add urls" },
		{ t("<"), i(1), t("> "), i(0) }
	),
	s(
		{ trig = "i", name = "Images", desc = "Add images" },
		{ t("!["), i(1, "alt text"), t("]("), i(2, "path"), t(") "), i(0) }
	),
	s({
		trig = "s",
		name = "Insert strikethrough",
		desc = "Insert strikethrough",
	}, { t("~~"), i(1), t("~~"), i(0) }),
	s(
		{ trig = "b", name = "Insert bold text", desc = "Insert bold text" },
		{ t("**"), i(1), t("**"), i(0) }
	),
	s({
		trig = "it",
		name = "Insert italic text",
		desc = "Insert italic text",
	}, { t("*"), i(1), t("*"), i(0) }),
	s(
		{ trig = "q", name = "Insert quoted text", desc = "Insert quoted text" },
		{ t("> "), i(1) }
	),
	s(
		{ trig = "c", name = "Insert code", desc = "Insert code" },
		{ t("`"), i(1), t("` "), i(0) }
	),
	s({
		trig = "cb",
		name = "Insert code block",
		desc = "Insert fenced code block",
	}, { t("```"), i(1, "language"), t({ "", "" }), i(0), t({ "", "```" }) }),
	s({
		trig = "hr",
		name = "Insert horizontal rule",
		desc = "Insert horizontal rule",
	}, { t({ "---", "" }) }),
	s({ trig = "tl", name = "Insert task list", desc = "Insert task list" }, {
		t("- ["),
		c(1, { t(" "), t("x") }),
		t("] "),
		i(2, "text"),
		t({ "", "" }),
		i(0),
	}),
	s({
		trig = "ta",
		name = "Insert table",
		desc = "Insert table with 2 rows and 2 columns. First row is heading.",
	}, {
		t("| "),
		i(1, "Column1"),
		t(" | "),
		i(2, "Column2"),
		t(" |"),
		t({ "", "| ------------- | -------------- |", "" }),
		t("| "),
		i(3, "Item1"),
		t(" | "),
		i(4, "Item1"),
		t(" |"),
		t({ "", "" }),
		i(0),
	}),
	s(
		{ trig = "n", name = "Insert Note", desc = "Insert Note" },
		{ t("> [!NOTE]", "> ") }
	),
	s(
		{ trig = "t", name = "Insert Tip", desc = "Insert Tip" },
		{ t("> [!TIP]", "> ") }
	),
	s(
		{ trig = "imp", name = "Insert Important", desc = "Insert Important" },
		{ t("> [!IMPORTANT]", "> ") }
	),
	s(
		{ trig = "w", name = "Insert Warning", desc = "Insert Warning" },
		{ t("> [!WARNING]", "> ") }
	),
	s(
		{ trig = "ca", name = "Insert Caution", desc = "Insert Caution" },
		{ t("> [!CAUTION]", "> ") }
	),
}
