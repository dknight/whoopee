<!-- Description: True-to-hardware ZX Spectrum colors - non-bright tones use roughly 85% of the bright color’s intensity. So non-bright colors might be not accurate. -->

tags: zx

# Hardware ZX Spectrum Colors

In the 1980s, the ZX Spectrum was designed for analog TV sets, at a time when
digital displays didn’t exist widely. This short article aims to stay true to
how the original ZX Spectrum actually displayed its colors.

The ZX Spectrum has two color modes: normal (high-contrast) colors and dim
(non-bright) versions of each color except black (black is always zero value).
On real hardware, the brightness of each color depended on the voltage output --
about 85% for normal colors and 100% for bright ones.

The dim or non-bright colors on the Spectrum don’t look like simple dimmed versions
of the bright ones. That’s because the Spectrum didn’t use digital color values like
modern computers do — it used analog voltage levels and very simple hardware
mixing for RGB.

Today we use digital displays, which show perfect colors, but in the past CRT displays were affected by many factors:

- Analog voltage levels were not exactly 85%;
- PAL color decoding caused hue shifts and smearing;
- TV tuning varied a lot between units.
- etc.

Because of these factors, almost every TV set had its own unique palette, which added extra charm.

Here is the ideal case: 85% voltage for dark colors.

<p>
<math xmlns="http://www.w3.org/1998/Math/MathML" display="inline">
  <mrow>
    <mi>0xFF</mi>
    <mo>&#x22C5;</mo>
    <mn>0.85</mn>
    <mo>=</mo>
    <mn>216.75</mn>
    <mo>&#x2248;</mo>
    <mn>216</mn>
    <mo>=</mo>
    <mi>0xD8</mi>
  </mrow>
</math>
</p>
<style>
.zx-color-table {
	letter-spacing: 0.125rem;
	max-width: 100%;
	td:not(:first-child) {
		width: 10rem;
		height: 2rem;
	}
}
</style>
<table class="zx-color-table">
	<caption>HEX Color palette</caption>
	<thead>
		<tr>
			<th></th>
			<th>Bright</th>
			<th>Non-right *</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>0</td>
			<td colspan="3" style="text-align: center; background: #000000; color: #FFFFFF">#000000</td>
		</tr>
		<tr>
			<td>1</td>
			<td  style="background: #0000FF; color: #FFFFFF;">#0000FF</td>
			<td  style="background: #0000D8; color: #FFFFFF;">#0000D8</td>
		</tr>
		<tr>
			<td>2</td>
			<td style="background: #FF0000; color: #FFFFFF;">#FF0000</td>
			<td style="background: #D80000; color: #FFFFFF;">#D80000</td>
		</tr>
		<tr>
			<td>3</td>
			<td style="background: #FF00FF; color: #000000">#FF00FF</td>
			<td style="background: #D800D8; color: #000000">#D800D8</td>
		</tr>
		<tr>
			<td>4</td>
			<td style="background: #00FF00; color: #000000">#00FF00</td>
			<td style="background: #00D800; color: #000000">#00D800</td>
		</tr>	
		<tr>
			<td>5</td>
			<td style="background: #00FFFF; color: #000000">#00FFFF</td>
			<td style="background: #00D8D8; color: #000000">#00D8D8</td>
		</tr>
		<tr>
			<td>6</td>
			<td style="background: #FFFF00; color: #000000">#FFFF00</td>
			<td style="background: #D8D800; color: #000000">#D8D800</td>
		</tr>
		<tr>
			<td>7</td>Colours
			<td style="background: #FFFFFF; color: #000000">#FFFFFF</td>
			<td style="background: #FFFFFF; color: #000000">#D8D8D8</td>
		</tr>
	</tbody>
</table>

* Perfect case 85% of bright color.