import { build } from 'esbuild';
import { mkdir, writeFile } from 'node:fs/promises';
import { execFileSync } from 'node:child_process';

await mkdir('dist', { recursive: true });
execFileSync(process.execPath, ['node_modules/typescript/bin/tsc'], { stdio: 'inherit' });
for (const [format, outfile] of [['esm', 'dist/index.js'], ['cjs', 'dist/index.cjs'], ['iife', 'dist/im-sdk.js']]) {
  await build({ entryPoints: ['src/index.ts'], bundle: true, format, outfile, globalName: 'IMSDK',
    platform: 'browser', target: ['es2020', 'safari14'], minify: true, legalComments: 'eof', sourcemap: false });
}
// Keep the dependency's notices with the self-contained browser bundle.
await writeFile('dist/THIRD_PARTY_NOTICES.txt', `@microsoft/signalr 8.0.17\nCopyright (c) .NET Foundation and Contributors\nMIT License\nhttps://github.com/dotnet/aspnetcore/tree/v8.0.17\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the "Software"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in\nall copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\nTHE SOFTWARE.\n`);
