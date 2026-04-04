import Color from './src/color.ts';

// ─── Helper ────────────────────────────────────────────────────────────────────

let passed = 0;
let failed = 0;

function test(label, fn) {
    try {
        fn();
        console.log(`%c✓ ${label}`, 'color: green');
        passed++;
    } catch (e) {
        console.error(`✗ ${label}\n  → ${e.message}`);
        failed++;
    }
}

function expect(actual, expected) {
    const a = JSON.stringify(actual);
    const e = JSON.stringify(expected);
    if (a !== e) throw new Error(`Expected ${e}, got ${a}`);
}

function expectNull(val) {
    if (val !== null) throw new Error(`Expected null, got ${JSON.stringify(val)}`);
}

function expectThrows(fn) {
    try { fn(); throw new Error('Tidak melempar error'); }
    catch (e) { if (e.message === 'Tidak melempar error') throw e; }
}

// ─── Constructor ───────────────────────────────────────────────────────────────

console.group('Constructor');

test('nilai valid', () => {
    const c = new Color(255, 128, 0);
    expect([c._red, c._green, c._blue], [255, 128, 0]);
});

test('melempar TypeError jika bukan angka', () => {
    expectThrows(() => new Color('255', 0, 0));
});

test('melempar RangeError jika nilai > 255', () => {
    expectThrows(() => new Color(256, 0, 0));
});

test('melempar RangeError jika nilai negatif', () => {
    expectThrows(() => new Color(0, -1, 0));
});

test('melempar RangeError jika nilai float', () => {
    expectThrows(() => new Color(0, 0, 1.5));
});

console.groupEnd();

// ─── Hex ───────────────────────────────────────────────────────────────────────

console.group('Hex');

test('isHex: #fff', () => expect(Color.isHex('#fff'), true));
test('isHex: #ffffff', () => expect(Color.isHex('#ffffff'), true));
test('isHex: #FFF (uppercase)', () => expect(Color.isHex('#FFF'), true));
test('isHex: #FFFFFF (uppercase)', () => expect(Color.isHex('#FFFFFF'), true));
test('isHex: invalid #gggggg', () => expect(Color.isHex('#gggggg'), false));
test('isHex: invalid tanpa #', () => expect(Color.isHex('ffffff'), false));
test('isHex: invalid 4 karakter', () => expect(Color.isHex('#ffff'), false));

test('parse #fff → putih', () => {
    const c = Color.parse('#fff');
    expect([c._red, c._green, c._blue], [255, 255, 255]);
});

test('parse #ffffff → putih', () => {
    const c = Color.parse('#ffffff');
    expect([c._red, c._green, c._blue], [255, 255, 255]);
});

test('parse #000 → hitam', () => {
    const c = Color.parse('#000');
    expect([c._red, c._green, c._blue], [0, 0, 0]);
});

test('parse #abc → expand shorthand', () => {
    const c = Color.parse('#abc');
    expect([c._red, c._green, c._blue], [170, 187, 204]);
});

test('parse #1a2b3c', () => {
    const c = Color.parse('#1a2b3c');
    expect([c._red, c._green, c._blue], [26, 43, 60]);
});

test('toHexString', () => {
    expect(new Color(255, 255, 255).toHexString(), '#ffffff');
});

test('toHexString padding nol', () => {
    expect(new Color(0, 0, 0).toHexString(), '#000000');
});

console.groupEnd();

// ─── RGB ───────────────────────────────────────────────────────────────────────

console.group('RGB');

test('isRgb: valid', () => expect(Color.isRgb('rgb(255, 0, 128)'), true));
test('isRgb: spasi fleksibel', () => expect(Color.isRgb('rgb( 255 , 0 , 128 )'), true));
test('isRgb: dengan persen', () => expect(Color.isRgb('rgb(100%, 0%, 50%)'), true));
test('isRgb: invalid nilai > 255', () => expect(Color.isRgb('rgb(256, 0, 0)'), false));
test('isRgb: invalid 2 nilai', () => expect(Color.isRgb('rgb(255, 0)'), false));
test('isRgb: invalid teks', () => expect(Color.isRgb('rgb(abc)'), false));

test('parse rgb(255, 0, 0) → merah', () => {
    const c = Color.parse('rgb(255, 0, 0)');
    expect([c._red, c._green, c._blue], [255, 0, 0]);
});

test('parse rgb dengan persen', () => {
    const c = Color.parse('rgb(100%, 0%, 0%)');
    expect([c._red, c._green, c._blue], [255, 0, 0]);
});

test('toRgbString', () => {
    expect(new Color(255, 0, 128).toRgbString(), 'rgb(255, 0, 128)');
});

console.groupEnd();

// ─── HSL ───────────────────────────────────────────────────────────────────────

console.group('HSL');

test('isHsl: valid', () => expect(Color.isHsl('hsl(360, 100%, 50%)'), true));
test('isHsl: h=0', () => expect(Color.isHsl('hsl(0, 0%, 0%)'), true));
test('isHsl: invalid s tanpa %', () => expect(Color.isHsl('hsl(0, 100, 50%)'), false));
test('isHsl: invalid h > 360', () => expect(Color.isHsl('hsl(361, 0%, 0%)'), false));
test('isHsl: invalid teks', () => expect(Color.isHsl('hsl(abc, 0%, 0%)'), false));

test('parse hsl(0, 100%, 50%) → merah', () => {
    const c = Color.parse('hsl(0, 100%, 50%)');
    expect([c._red, c._green, c._blue], [255, 0, 0]);
});

test('parse hsl achromatic (s=0)', () => {
    const c = Color.parse('hsl(0, 0%, 100%)');
    expect([c._red, c._green, c._blue], [255, 255, 255]);
});

test('toHslString round-trip', () => {
    const c = new Color(255, 0, 0);
    expect(c.toHslString(), 'hsl(0, 100%, 50%)');
});

console.groupEnd();

// ─── parse() return null ────────────────────────────────────────────────────────

console.group('parse() → null');

test('format tidak dikenali', () => expectNull(Color.parse('biru')));
test('string kosong', () => expectNull(Color.parse('')));
test('input bukan string (number)', () => expectNull(Color.parse(123)));
test('input null', () => expectNull(Color.parse(null)));

console.groupEnd();

// ─── Utilities ─────────────────────────────────────────────────────────────────

console.group('Utilities');

test('equals: sama', () => {
    expect(new Color(1, 2, 3).equals(new Color(1, 2, 3)), true);
});

test('equals: berbeda', () => {
    expect(new Color(1, 2, 3).equals(new Color(1, 2, 4)), false);
});

test('toString = toRgbString', () => {
    const c = new Color(255, 0, 128);
    expect(c.toString(), c.toRgbString());
});

console.groupEnd();

// ─── Summary ───────────────────────────────────────────────────────────────────

console.log(`\n%c${passed} passed, ${failed} failed`, `color: ${failed ? 'red' : 'green'}; font-weight: bold`);