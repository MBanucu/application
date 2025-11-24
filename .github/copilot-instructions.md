# Copilot Instructions for Job Application Generator

## Architecture Overview
This is a LaTeX-based job application generator supporting German and English outputs. The system uses XML parameters, multi-language text snippets, and Python translation to produce compiled PDFs.

- **Core Components**:
  - `parameters/parameters.xml`: Defines application-specific data (receiver details, position, etc.) as LaTeX commands.
  - `languageDB/`: Numbered folders (001/, 002/, etc.) containing `English.tex` and `German.tex` with translated text blocks.
  - `texProject/`: LaTeX templates with `\versionLanguageStart%NNN ... \versionLanguageEnd` placeholders.
  - `translator.py`: Replaces placeholders by matching English content to languageDB entries.
  - `build.sh`: Orchestrates translation, LaTeX compilation, and PDF concatenation.

- **Data Flow**:
  1. XML parameters processed into LaTeX commands (via translator).
  2. Templates copied to `build/$language/` and translated.
  3. LaTeX compiled with `latexmk -pdf`.
  4. PDFs concatenated using `pdftk` into final application document.

- **Structural Decisions**: Modular subprojects (Anschreiben, Lebenslauf, etc.) allow independent updates. LanguageDB enables fine-grained translation without duplicating entire documents.

## Key Workflows
- **Build Process**: Run `./build.sh` from `Bewerbung/` (or Ctrl+Shift+B in VS Code). Requires nix-shell environment with LaTeX tools.
- **Translation**: `python translator.py $language $project` scans `.tex` files for placeholders and replaces with languageDB content.
- **Debugging**: Check LaTeX logs in `build/$language/` for compilation errors. Use `evince` to preview PDFs.
- **Adding Content**: Create new numbered folder in `languageDB/`, add English/German `.tex` with `\versionLanguageStart%NNN ... \versionLanguageEnd` wrapper in templates.

## Project Conventions
- **Language Handling**: English files include full placeholder tags; German files contain only translated content. Translator matches exact English text blocks.
- **Parameter Integration**: Use `\newcommand{\var}{value}` in XML-derived files. Access via `\csname address\useAddress Street\endcsname` for dynamic addresses.
- **File Organization**: `texProject/` for templates, `build/$language/` for generated files, `generated/` for imported parameters.
- **PDF Assembly**: Order: Anschreiben (cover letter) + Deckblatt (cover sheet) + Lebenslauf (CV) + Anhang (attachments).

## Examples
- **Adding a Translated Section**: In `Anschreiben/languageDB/017/English.tex`: `\versionLanguageStart%017 New paragraph text \versionLanguageEnd`. In `German.tex`: `Neuer Absatz Text`. Insert `%017` placeholder in `texProject/document.tex`.
- **Updating Receiver**: Edit `parameters/parameters.xml` `<command name="newcommand"><parameter>\companyReceiver</parameter><parameter>New Company</parameter></command>` to change the receiver's company.
