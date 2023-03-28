import re
import os
import sys
from distutils.dir_util import copy_tree

def translateDocument(language: str, rootDirLanguageDB: str, documentFile: str):
    pattern = '\\\\versionLanguageStart((?!\\\\versionLanguageEnd)([!\\\\]|.|\\s))*\\\\versionLanguageEnd'
    documentText = ""
    with open(documentFile) as file:
        documentText = file.read()
    documentTextReplaced = ""
    documentTextPointer = 0
    for match in re.finditer(pattern, documentText):
        shit = ""
        newTextPointer = match.span()[0]
        documentTextReplaced += documentText[documentTextPointer:newTextPointer]
        documentTextPointer = newTextPointer
        for element in os.listdir(os.fsencode(rootDirLanguageDB)):
            path = os.path.join(rootDirLanguageDB, os.fsdecode(element), "English.tex")
            compareText = ""
            with open(path) as compareFile:
                compareText = compareFile.read()
            if (match.group() == compareText):
                shit = os.fsdecode(element)
                break
        if (shit == ""):
            print(match.group())
            newTextPointer = match.span()[1]
            documentTextReplaced += documentText[documentTextPointer:newTextPointer]
            documentTextPointer = newTextPointer
            continue
        replaceText = ""
        with open(os.path.join(rootDirLanguageDB, shit, language + ".tex")) as file:
            replaceText = file.read()
        documentTextReplaced += replaceText
        documentTextPointer = match.span()[1]
    documentTextReplaced += documentText[documentTextPointer:]
    with open(documentFile, "w") as file:
        file.write(documentTextReplaced)

def copyTexBuildFiles(buildDir: str):
    for x in ["source", "."]:
        copy_tree("texProject", os.path.join(buildDir, x))

cwd = os.getcwd()
projectRootDir = os.path.abspath(sys.argv[2])
os.chdir(projectRootDir)
projectBuildDir = os.path.join(projectRootDir, "build")

language = sys.argv[1]
languageBuildDir = os.path.join(projectBuildDir, language)
copyTexBuildFiles(languageBuildDir)

os.chdir(languageBuildDir)
projectDirLanguageDB = os.path.join(projectRootDir, "languageDB")
for element in os.listdir(os.fsencode(".")):
    elementStr = os.fsdecode(element)
    if (not elementStr.endswith(".tex")):
        continue
    path = os.path.join(languageBuildDir, elementStr)
    translateDocument(language, projectDirLanguageDB, path)
os.chdir(cwd)