# @tailwindcss/typography — Tailwind v4 Remake

Remake lengkap dari plugin `@tailwindcss/typography` yang dibangun khusus untuk **Tailwind CSS v4**, menggunakan sintaks CSS-native baru (`@utility`, `@variant`, CSS custom properties).

## Perbedaan dengan versi asli (v3)

| Fitur             | v3 (asli)                           | v4 (remake ini)               |
| ----------------- | ----------------------------------- | ----------------------------- |
| Format plugin     | `require()` di `tailwind.config.js` | `@import` CSS biasa           |
| Custom utilities  | JavaScript API                      | `@utility` directive          |
| Custom variants   | JavaScript API                      | `@variant` directive          |
| Konfigurasi       | `tailwind.config.js`                | CSS variables langsung        |
| Custom tema warna | `theme.extend.typography`           | `@utility prose-pink { ... }` |

## Instalasi

Cukup import file CSS ke stylesheet utama:

```css
/* main.css */
@import "tailwindcss";
@import "./src/index.css"; /* plugin ini */
```

## Penggunaan Dasar

```html
<article class="prose">
    <!-- HTML dari Markdown, CMS, dsb. -->
</article>
```

## Color Themes

```html
<article class="prose prose-gray">...</article>
<!-- default -->
<article class="prose prose-slate">...</article>
<article class="prose prose-zinc">...</article>
<article class="prose prose-neutral">...</article>
<article class="prose prose-stone">...</article>
```

## Size Modifiers

```html
<article class="prose prose-sm">...</article>
<!-- 14px -->
<article class="prose prose-base">...</article>
<!-- 16px, default -->
<article class="prose prose-lg">...</article>
<!-- 18px -->
<article class="prose prose-xl">...</article>
<!-- 20px -->
<article class="prose prose-2xl">...</article>
<!-- 24px -->
```

Bisa dikombinasikan dengan breakpoint:

```html
<article class="prose md:prose-lg lg:prose-xl">...</article>
```

## Dark Mode

```html
<article class="prose dark:prose-invert">...</article>
```

## Element Modifiers

```html
<article class="prose prose-img:rounded-xl prose-headings:underline prose-a:text-blue-600">...</article>
```

Daftar semua element modifier yang tersedia:

| Modifier                    | Target               |
| --------------------------- | -------------------- |
| `prose-headings:*`          | `h1, h2, h3, h4, th` |
| `prose-lead:*`              | `.lead`              |
| `prose-h1:*` – `prose-h4:*` | heading individual   |
| `prose-p:*`                 | `p`                  |
| `prose-a:*`                 | `a`                  |
| `prose-blockquote:*`        | `blockquote`         |
| `prose-figure:*`            | `figure`             |
| `prose-figcaption:*`        | `figcaption`         |
| `prose-strong:*`            | `strong`             |
| `prose-em:*`                | `em`                 |
| `prose-kbd:*`               | `kbd`                |
| `prose-code:*`              | `code`               |
| `prose-pre:*`               | `pre`                |
| `prose-ol:*`                | `ol`                 |
| `prose-ul:*`                | `ul`                 |
| `prose-li:*`                | `li`                 |
| `prose-table:*`             | `table`              |
| `prose-thead:*`             | `thead`              |
| `prose-tr:*`                | `tr`                 |
| `prose-th:*`                | `th`                 |
| `prose-td:*`                | `td`                 |
| `prose-img:*`               | `img`                |
| `prose-video:*`             | `video`              |
| `prose-hr:*`                | `hr`                 |

## Not-Prose (Escape Hatch)

```html
<article class="prose">
    <h1>Judul</h1>
    <div class="not-prose">
        <!-- Blok ini tidak mewarisi style prose -->
    </div>
</article>
```

## Custom Color Theme

Buat tema warna sendiri dengan `@utility`:

```css
@utility prose-pink {
    --tw-prose-body: var(--color-pink-800);
    --tw-prose-headings: var(--color-pink-900);
    --tw-prose-lead: var(--color-pink-700);
    --tw-prose-links: var(--color-pink-900);
    --tw-prose-bold: var(--color-pink-900);
    --tw-prose-counters: var(--color-pink-600);
    --tw-prose-bullets: var(--color-pink-400);
    --tw-prose-hr: var(--color-pink-300);
    --tw-prose-quotes: var(--color-pink-900);
    --tw-prose-quote-borders: var(--color-pink-300);
    --tw-prose-captions: var(--color-pink-700);
    --tw-prose-code: var(--color-pink-900);
    --tw-prose-pre-code: var(--color-pink-100);
    --tw-prose-pre-bg: var(--color-pink-900);
    --tw-prose-th-borders: var(--color-pink-300);
    --tw-prose-td-borders: var(--color-pink-200);
    /* ... token invert ... */
}
```

## CSS Custom Properties

Semua warna bisa di-override langsung via CSS variables:

```css
.prose {
    --tw-prose-links: var(--color-blue-600);
    --tw-prose-headings: var(--color-indigo-900);
}
```

## Struktur File

```
src/
  index.css          ← plugin utama (import ini)
demo/
  index.html         ← demo interaktif
README.md
```
