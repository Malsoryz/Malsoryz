export default class Color {

    protected _red: number;
    protected _green: number;
    protected _blue: number;

    /**
     * @param red - Integer 0-255 
     * @param green - Integer 0-255 
     * @param blue - Integer 0-255 
     */
    constructor(red: number, green: number, blue: number) {
        const channels: [string, number][] = [['red', red], ['green', green], ['blue', blue]];

        for (const [name, val] of channels) {
            if (typeof val !== 'number' || !Number.isFinite(val)) {
                throw new TypeError(`Channel '${name}' harus berupa angka, diterima: ${val}`);
            }
            if (!Number.isInteger(val) || val < 0 || val > 255) {
                throw new RangeError(`Channel '${name}' harus integer 0–255, diterima: ${val}`);
            }
        }

        this._red = red;
        this._green = green;
        this._blue = blue;
    }

    get red(): number { return this._red; }
    get green(): number { return this._green; }
    get blue(): number { return this._blue; }

    /**
     * @example
     * Color.parse('#fff')
     * Color.parse('rgb(255, 0, 0)')
     * Color.parse('hsl(0, 100%, 50%)')
     */
    static parse(str: string): Color | null {
        if (typeof str !== 'string' || !str.trim()) {
            console.error('Color.parse: input harus berupa string non-kosong');
            return null;
        }

        const s = str.trim();

        try {
            if (Color.isHex(s)) return Color.parseHex(s);
            if (Color.isRgb(s)) return Color.parseRgb(s);
            if (Color.isHsl(s)) return Color.parseHsl(s);
        } catch (error) {
            const msg = error instanceof Error ? error.message : String(error);
            console.error('Color.parse gagal:', msg);
            return null;
        }

        console.error(`Color.parse: format tidak dikenali → "${str}"`);
        return null;
    }

    // ─── Hex ───────────────────────────────────────────────────────────────────

    static isHex(str: string): boolean {
        return /^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(str);
    }

    static parseHex(hex: string): Color {
        if (!Color.isHex(hex)) {
            throw new Error(`Format hex tidak valid: "${hex}"`);
        }

        let h = hex.slice(1);

        if (h.length === 3) {
            h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2];
        }

        return new Color(
            parseInt(h.slice(0, 2), 16),
            parseInt(h.slice(2, 4), 16),
            parseInt(h.slice(4, 6), 16),
        );
    }

    toHexString(): string {
        return '#' + [this._red, this._green, this._blue]
            .map(v => v.toString(16).padStart(2, '0'))
            .join('');
    }

    // ─── RGB ───────────────────────────────────────────────────────────────────

    static isRgb(str: string): boolean {
        const match = str.match(/^rgb\s*\(\s*([^)]+)\s*\)$/i);
        if (!match) return false;

        const parts = match[1].split(',').map(x => x.trim());
        if (parts.length !== 3) return false;

        return parts.every(v => {
            if (v.endsWith('%')) {
                const num = parseFloat(v);
                return !isNaN(num) && num >= 0 && num <= 100;
            }
            const num = Number(v);
            return Number.isInteger(num) && num >= 0 && num <= 255;
        });
    }

    static parseRgb(rgb: string): Color {
        if (!Color.isRgb(rgb)) {
            throw new Error(`Format RGB tidak valid: "${rgb}"`);
        }

        const match = rgb.match(/^rgb\s*\(\s*([^)]+)\s*\)$/i);
        const [r, g, b] = match![1].split(',').map(v => {
            const trimmed = v.trim();
            if (trimmed.endsWith('%')) {
                return Math.round(parseFloat(trimmed) * 2.55);
            }
            return Number(trimmed);
        });

        return new Color(r, g, b);
    }

    toRgbString(): string {
        return `rgb(${this._red}, ${this._green}, ${this._blue})`;
    }

    // ─── HSL ───────────────────────────────────────────────────────────────────

    static isHsl(str: string): boolean {
        const match = str.match(/^hsl\s*\(\s*([^)]+)\s*\)$/i);
        if (!match) return false;

        const parts = match[1].split(',').map(x => x.trim());
        if (parts.length !== 3) return false;

        const [h, s, l] = parts;
        const hNum = Number(h);
        const sNum = parseFloat(s);
        const lNum = parseFloat(l);

        return (
            !isNaN(hNum) && hNum >= 0 && hNum <= 360 &&
            s.endsWith('%') && !isNaN(sNum) && sNum >= 0 && sNum <= 100 &&
            l.endsWith('%') && !isNaN(lNum) && lNum >= 0 && lNum <= 100
        );
    }

    static parseHsl(hsl: string): Color {
        if (!Color.isHsl(hsl)) {
            throw new Error(`Format HSL tidak valid: "${hsl}"`);
        }

        const match = hsl.match(/^hsl\s*\(\s*([^)]+)\s*\)$/i);
        const [h, s, l] = match![1].split(',').map(v => v.trim());

        const H = Number(h);
        const S = parseFloat(s) / 100;
        const L = parseFloat(l) / 100;

        let r: number, g: number, b: number;

        if (S === 0) {
            r = g = b = L;
        } else {
            const hue2rgb = (p: number, q: number, t: number) => {
                if (t < 0) t += 1;
                if (t > 1) t -= 1;
                if (t < 1 / 6) return p + (q - p) * 6 * t;
                if (t < 1 / 2) return q;
                if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
                return p;
            };

            const q = L < 0.5 ? L * (1 + S) : L + S - L * S;
            const p = 2 * L - q;
            const hNorm = H / 360;

            r = hue2rgb(p, q, hNorm + 1 / 3);
            g = hue2rgb(p, q, hNorm);
            b = hue2rgb(p, q, hNorm - 1 / 3);
        }

        return new Color(
            Math.round(r * 255),
            Math.round(g * 255),
            Math.round(b * 255),
        );
    }

    toHslString(): string {
        const r = this._red / 255;
        const g = this._green / 255;
        const b = this._blue / 255;

        const max = Math.max(r, g, b);
        const min = Math.min(r, g, b);
        const d = max - min;

        let h = 0;
        let s = 0;
        const l = (max + min) / 2;

        if (d !== 0) {
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

            switch (max) {
                case r: h = ((g - b) / d + (g < b ? 6 : 0)) / 6; break;
                case g: h = ((b - r) / d + 2) / 6; break;
                case b: h = ((r - g) / d + 4) / 6; break;
            }
        }

        return `hsl(${Math.round(h * 360)}, ${Math.round(s * 100)}%, ${Math.round(l * 100)}%)`;
    }

    // ─── Utilities ─────────────────────────────────────────────────────────────

    equals(other: Color): boolean {
        return (
            other instanceof Color &&
            this.red === other.red &&
            this.green === other.green &&
            this.blue === other.blue
        );
    }

    toString(): string {
        return this.toRgbString();
    }
}