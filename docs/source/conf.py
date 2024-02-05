# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import shutil

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "mplib"
author = "Minghua Liu, Jiayuan Gu, Kolin Guo, Xinsong Lin"
copyright = f"2021-2024, {author}. All rights reserved."
release = "0.1.0"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.duration",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    "sphinx_rtd_theme",
    "myst_parser",
]

templates_path = ["_templates"]
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]


def copy_readme_gif(app, docname):
    if app.builder.name == "html":
        print(app.srcdir)
        source = os.path.join(app.srcdir, "..", "..", "demo.gif")
        target = os.path.join(app.outdir, "demo.gif")
        shutil.copyfile(source, target)


def setup(app):
    app.connect("build-finished", copy_readme_gif)
