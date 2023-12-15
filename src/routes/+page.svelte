<script lang="ts">
	import { page } from '$app/stores';
	import type { Category } from '$lib/models';
	import { onMount } from 'svelte';

	let mainCategories: Array<Category> = [];
	let displayedCategories: Array<Category> = [];
	let selectedMainCategory: Array<string> = [];

	let display = false;
	let url = $page.url.href;

	async function parseCSV(file: string): Promise<Array<Array<string>>> {
		const response = await fetch(file);
		const text = await response.text();
		const lines = text.split('\n');
		lines.shift(); // Remove the first line (header)
		return lines.map((line) => line.split(','));
	}
	

	async function parse() {
		const mainCatLines = await parseCSV(url + '/main.csv');
		const catLines = await parseCSV(url + '/category.csv');
		const itemLines = await parseCSV(url + '/items.csv');

		let categories = catLines.map(([category_label, category_index]) => ({
			category_index: category_index?.replace('\r', ''), // Remove the carriage return "\r
			category_label,
			checked: true,
			items: itemLines
				.filter(([pictogram_label, pictogram_file, pictogram_category]) =>
					pictogram_category?.split(';').find((cat) => cat === category_index?.replace('\r', ''))
				)
				.map(([pictogram_label, pictogram_file, pictogram_category]) => ({
					pictogram_file,
					pictogram_label
				}))
		}));
		// if categorie is in mainCatLines.category_index then add mainCatLines.category_label to mainCategories
		const parseCat = mainCatLines.map(([category_label, category_index]) => {
			if (category_index.split(';')[1] === undefined) {
				category_index = category_index.replace(/\s/g, '');
				return {
					category_index: category_index, // No need to split for one-item categories
					category_label: category_label,
					checked: true,
					toggle: false,
					sub_categorie_items: [categories.find((cat) => cat.category_index === category_index)!]
				};
			} else {
				return {
					category_index: category_index.replace('\r', ''), // Remove the carriage return "\r"
					category_label: category_label,
					checked: true,
					toggle: false,
					sub_categorie_items: category_index
						.split(';')
						.map((index) => categories.find((cat) => cat.category_index === index)!)
				};
			}
		});
		mainCategories = parseCat;
		displayedCategories = parseCat;
		display = true;
	}

	async function removeItem(categoriesIndex: number, categoryIndex: number, itemIndex: number) {
		const spliced = displayedCategories.filter((cat, catIndex) => {
			if (catIndex === categoriesIndex) {
				cat.sub_categorie_items[categoryIndex].items.splice(itemIndex, 1);
			}
			return cat;
		});
		displayedCategories = spliced;
	}

	async function checkUncheckAll(index: number) {
		const spliced = displayedCategories.filter((cat, catIndex) => {
			if (catIndex === index) {
				cat.sub_categorie_items.forEach((subCat) => {
					if(subCat){
						subCat.checked = !subCat.checked;
					}

				});
			}
			return cat;
		});
		displayedCategories = spliced
	}

	onMount(() => {
		parse();
	});
</script>

<section class="w-3/4 print:w-full m-auto">
	<div class="flex justify-center p-4">
		<div class="flex flex-col w-1/3 items-center">
			<img src={url + '/logos/interpretable.png'} alt="logo" class="pr-4 w-32" />
			<img src={url + '/logos/logo_erasme_entete.png'} alt="logo" class="h-auto" />
		</div>
	</div>

	<div class="text-left text-2xl">
		Interprétable est un outil de communication utilisant des pictogrammes.<br />
		Il a été développé par le laboratoire d'innovation ouverte Erasme de la Métropole de Lyon.<br />
		Pour plus d'information visitez la page
		<a class="text-purple-600" href="https://erasme.org/interpretable" target="_blank"
			>https://erasme.org/interpretable</a
		>.<br />
	</div>

	<button
		class="print:hidden border-black border uppercase p-3 text-black fixed bottom-5 right-5 flex items-center hover:scale-125"
		on:click={() => window.print()}
	>
		<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 512 512">
			<style>
			</style><path
				d="M128 0C92.7 0 64 28.7 64 64v96h64V64H354.7L384 93.3V160h64V93.3c0-17-6.7-33.3-18.7-45.3L400 18.7C388 6.7 371.7 0 354.7 0H128zM384 352v32 64H128V384 368 352H384zm64 32h32c17.7 0 32-14.3 32-32V256c0-35.3-28.7-64-64-64H64c-35.3 0-64 28.7-64 64v96c0 17.7 14.3 32 32 32H64v64c0 35.3 28.7 64 64 64H384c35.3 0 64-28.7 64-64V384zM432 248a24 24 0 1 1 0 48 24 24 0 1 1 0-48z"
			/></svg
		>
		<p class="ml-4 font-bold">Imprimer</p>
	</button>

	<div class="print:hidden">
		<h1 class="text-2xl font-bold mt-6 mb-6">SELECTIONNEZ LES CATÉGORIES À AFFICHER</h1>
		{#if display}
			<div class="flex h-48">
				<select
					multiple
					class="w-1/3 uppercase bold"
					bind:value={selectedMainCategory}
				>
					{#each displayedCategories as categories}
						{#if categories.checked}
							<option class="" value={categories.category_index}
								>{categories?.category_label}</option
							>
						{/if}
					{/each}
				</select>
				<div class="overflow-y-scroll p-2">
					{#each displayedCategories as categories, categoriesIndex}
						{#if selectedMainCategory.includes(categories.category_index)}
							{#if categories.sub_categorie_items}
								<div class="uppercase flex">
									<input
										type="checkbox"
										checked
										on:click={async () => {await checkUncheckAll(categoriesIndex)}}
										class="mr-2"
									/>
									Sélectionner/Déselectionner tout
								</div>
								{#each categories.sub_categorie_items as category}
									{#if category}
										<div class="uppercase flex pt-1 pb-1">
											<input
												type="checkbox"
												bind:checked={category.checked}
												class="mr-2"
											/>
											{category?.category_label}
										</div>
									{/if}
								{/each}
							{/if}
						{/if}
					{/each}
				</div>
			</div>

		{/if}
	</div>
	<div class="print:break-before-page">
		{#if display}
			{#each displayedCategories as categories, categoriesIndex}
				{#if categories.checked}
				<div class="print:h-screen print:flex print:justify-center print:items-center print:break-after-page print:break-before-page ">
					<h1 class="text-4xl">{categories?.category_label}</h1>
				</div>
					{#each categories.sub_categorie_items as category, categoryIndex}
						{#if category?.checked}
							<h1 class="text-xl print:[&:not(:first-child)]:break-before-page mt-4 mb-4">
								{category?.category_label}
							</h1>
							<ul class="flex flex-wrap justify-center">
								{#if category?.items}
									{#each category.items as item, itemIndex}
										<li
											class="w-1/3 md:w-1/5 lg:w-1/6 print:w-1/4 print:h-72 border border-solid p-2 border-black m-1"
										>
											<button
												class="print:hidden absolute -m-5 hover:scale-125"
												on:click={() => removeItem(categoriesIndex, categoryIndex, itemIndex)}
											>
												<svg xmlns="http://www.w3.org/2000/svg" height="2em" viewBox="0 0 512 512">
													<style>
													</style><path
														d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c9.4-9.4 24.6-9.4 33.9 0l47 47 47-47c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-47 47 47 47c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-47-47-47 47c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l47-47-47-47c-9.4-9.4-9.4-24.6 0-33.9z"
													/></svg
												>
											</button>
											<img
												src={url + '/svg/' + item.pictogram_file + '.svg'}
												alt={item.pictogram_label}
												class="print:h-48 print:landscape:h-44"
												loading="lazy"
											/>
											<p class="pb-2 text-center">{item.pictogram_label}</p>
										</li>
									{/each}
								{/if}
							</ul>
						{/if}
					{/each}
				{/if}
			{/each}
		{/if}
	</div>
</section>
