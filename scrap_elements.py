# This whole file is ugly don't mind me

from pprint import pprint

# https://periodictableguide.com/electron-configuration-chart-of-all-elements/
from_website = """| 1  | Electron configuration of Hydrogen (H)   | 1s1          | 1s1                 | 1#       |
| 2  | Electron configuration of Helium (He)    | 1s2          | 1s2                 | 2#       |
| 3  | Electron configuration of Lithium (Li)   | [He] 2s1     | 1s2 2s1             | 2, 1#    |
| 4  | Electron configuration of Beryllium (Be) | [He] 2s2     | 1s2 2s2             | 2, 2#    |
| 5  | Electron configuration of Boron (B)      | [He] 2s2 2p1 | 1s2 2s2 2p1         | 2, 3#    |
| 6  | Electron configuration of Carbon (C)     | [He] 2s2 2p2 | 1s2 2s2 2p2         | 2, 4#    |
| 7  | Electron configuration of Nitrogen (N)   | [He] 2s2 2p3 | 1s2 2s2 2p3         | 2, 5#    |
| 8  | Electron configuration of Oxygen (O)     | [He] 2s2 2p4 | 1s2 2s2 2p4         | 2, 6#    |
| 9  | Electron configuration of Fluorine (F)   | [He] 2s2 2p5 | 1s2 2s2 2p5         | 2, 7#    |
| 10 | Electron configuration of Neon (Ne)      | [He] 2s2 2p6 | 1s2 2s2 2p6         | 2, 8#    |
| 11 | Electron configuration of Sodium (Na)    | [Ne] 3s1     | 1s2 2s2 2p6 3s1     | 2, 8, 1# |
| 12 | Electron configuration of Magnesium (Mg) | [Ne] 3s2     | 1s2 2s2 2p6 3s2     | 2, 8, 2# |
| 13 | Electron configuration of Aluminum (Al)  | [Ne] 3s2 3p1 | 1s2 2s2 2p6 3s2 3p1 | 2, 8, 3# |
| 14 | Electron configuration of Silicon (Si)   | [Ne] 3s2 3p2 | 1s2 2s2 2p6 3s2 3p2 | 2, 8, 4# |
| 15 | Electron configuration of Phosphorus (P) | [Ne] 3s2 3p3 | 1s2 2s2 2p6 3s2 3p3 | 2, 8, 5# |
| 16 | Electron configuration of Sulfur (S)     | [Ne] 3s2 3p4 | 1s2 2s2 2p6 3s2 3p4 | 2, 8, 6# |
| 17 | Electron configuration of Chlorine (Cl)  | [Ne] 3s2 3p5 | 1s2 2s2 2p6 3s2 3p5 | 2, 8, 7# |
| 18 | Electron configuration of Argon (Ar)     | [Ne] 3s2 3p6 | 1s2 2s2 2p6 3s2 3p6 | 2, 8, 8# |"""

elements = [el.split("|") for el in from_website.split("\n")]

elements = [
    {
        "number": el[1].strip(),
        "symbol": el[2].replace("Electron configuration of ", "").split("(")[1].split(")")[0],
        "name": el[2].replace("Electron configuration of ", "").strip().split(" ")[0],
        "conf_short": el[3].strip(),
        "conf_full": el[4].strip(),
        "shells": [s.strip() for s in el[5].replace("#", "").split(",")],
    }
    for el in elements
]

element_template = """    {{
        number = {},
        symbol = "{}",
        name = "{}",
        conf_short = "{}",
        conf_full = "{}",
        shells = {{ {} }},
    }},\n"""

with open("elements.lua", "w") as f:
    f.write("elements = {\n")

    for element in elements:
        f.write(
            element_template.format(
                element["number"],
                element["symbol"],
                element["name"],
                element["conf_short"],
                element["conf_full"],
                ', '.join(element["shells"]),
            )
        )
    f.write("}\n")
