#!/usr/bin/env -S deno run

const width = Deno.stdout.isTerminal()
  ? Math.min(Deno.consoleSize().columns, 128)
  : 80;

function print(s: string) {
  Deno.stdout.writeSync(new TextEncoder().encode(s));
}

print(
  `|039| \x1b[039mDefault\x1b[m |049| \x1b[049mDefault \x1b[m |037| \x1b[037mLight gray   \x1b[m |047| \x1b[047mLight gray    \x1b[m
|030| \x1b[030mBlack  \x1b[m |040| \x1b[040mBlack   \x1b[m |090| \x1b[090mDark gray    \x1b[m |100| \x1b[100mDark gray     \x1b[m
|031| \x1b[031mRed    \x1b[m |041| \x1b[041mRed     \x1b[m |091| \x1b[091mLight red    \x1b[m |101| \x1b[101mLight red     \x1b[m
|032| \x1b[032mGreen  \x1b[m |042| \x1b[042mGreen   \x1b[m |092| \x1b[092mLight green  \x1b[m |102| \x1b[102mLight green   \x1b[m
|033| \x1b[033mYellow \x1b[m |043| \x1b[043mYellow  \x1b[m |093| \x1b[093mLight yellow \x1b[m |103| \x1b[103mLight yellow  \x1b[m
|034| \x1b[034mBlue   \x1b[m |044| \x1b[044mBlue    \x1b[m |094| \x1b[094mLight blue   \x1b[m |104| \x1b[104mLight blue    \x1b[m
|035| \x1b[035mMagenta\x1b[m |045| \x1b[045mMagenta \x1b[m |095| \x1b[095mLight magenta\x1b[m |105| \x1b[105mLight magenta \x1b[m
|036| \x1b[036mCyan   \x1b[m |046| \x1b[046mCyan    \x1b[m |096| \x1b[096mLight cyan   \x1b[m |106| \x1b[106mLight cyan    \x1b[m

`,
);

function range(start: number, end: number): number[] {
  return [...Array(end - start)].map((_, i) => start + i);
}

const liness = [
  [[range(0, 8)], [range(8, 16)]],
  [
    [range(16, 22), range(52, 58), range(88, 94)],
    [range(22, 28), range(58, 64), range(94, 100)],
    [range(28, 34), range(64, 70), range(100, 106)],
    [range(34, 40), range(70, 76), range(106, 112)],
    [range(40, 46), range(76, 82), range(112, 118)],
    [range(46, 52), range(82, 88), range(118, 124)],
  ],
  [
    [range(124, 130), range(160, 166), range(196, 202)],
    [range(130, 136), range(166, 172), range(202, 208)],
    [range(136, 142), range(172, 178), range(208, 214)],
    [range(142, 148), range(178, 184), range(214, 220)],
    [range(148, 154), range(184, 190), range(220, 226)],
    [range(154, 160), range(190, 196), range(226, 232)],
  ],
  [[range(232, 244)], [range(244, 256)]],
];

for (const lines of liness) {
  for (const line of lines) {
    for (const j of range(0, 2)) {
      for (const [i, col] of line.entries()) {
        if (i > 0) {
          print("  ");
        }
        for (const c of col) {
          print(`\x1b[48;5;${c}m${(j === 1 ? `${c}` : "").padStart(4, " ")}`);
        }
        print("\x1b[m");
      }
      print("\n");
    }
  }
  print("\n");
}

// r, g, b: [0, 255]
function rgb(r: number, g: number, b: number): string {
  return `\x1b[48;2;${Math.floor(r)};${Math.floor(g)};${Math.floor(b)}m`;
}

// h: [0, 360]
// s, v: [0, 1]
function hsv(h: number, s: number, v: number): string {
  const i = Math.floor((h * 6) / 360);
  const c = v * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = v - c;

  switch (i) {
    case 0:
      return rgb((c + m) * 255, (x + m) * 255, m * 255);
    case 1:
      return rgb((x + m) * 255, (c + m) * 255, m * 255);
    case 2:
      return rgb(m * 255, (c + m) * 255, (x + m) * 255);
    case 3:
      return rgb(m * 255, (x + m) * 255, (c + m) * 255);
    case 4:
      return rgb((x + m) * 255, m * 255, (c + m) * 255);
    default:
      return rgb((c + m) * 255, m * 255, (x + m) * 255);
  }
}

for (let i = 0; i < width; i++) {
  print(rgb((i / width) * 255, 0, 0));
  print(" ");
}
print("\x1b[m\n");

for (let i = 0; i < width; i++) {
  print(rgb(0, (i / width) * 255, 0));
  print(" ");
}
print("\x1b[m\n");

for (let i = 0; i < width; i++) {
  print(rgb(0, 0, (i / width) * 255));
  print(" ");
}
print("\x1b[m\n\n");

for (let i = 0; i < width; i++) {
  print(hsv((i / width) * 180, 1.0, 1.0));
  print(" ");
}
print("\x1b[m\n");

for (let i = 0; i < width; i++) {
  print(hsv(360 - (i / width) * 180, 1.0, 1.0));
  print(" ");
}
print("\x1b[m\n\n");
