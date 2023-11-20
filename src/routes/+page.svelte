<script lang="ts">
	import { page } from '$app/stores';
	import { onMount } from 'svelte';

	let mainCategories = [];
	let displayedCategories = [];

	let selectedCategories = [];

	async function parseCSV(file) {
		const response = await fetch(file);
		const text = await response.text();
		const lines = text.split('\n');
		lines.shift(); // Remove the first line (header)
		return lines.map((line) => line.split(','));
	}
	let display = false;

	let url = $page.url.href;

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
		mainCategories = mainCatLines.map(([category_label, category_index]) => ({
			category_index: category_index.replace('\r', ''), // Remove the carriage return "\r
			category_label: category_label,
			checked: true,
			toggle: false,
			sub_categorie_items: category_index
				.split(';')
				.map((index) => categories.find((cat) => cat.category_index === index))
		}));

		displayedCategories = mainCategories;
		display = true;
	}

	function removeItem(categoriesIndex, categoryIndex, itemIndex) {
		const spliced = displayedCategories.filter((cat, catIndex) => {
			if (catIndex === categoriesIndex) {
				cat.sub_categorie_items[categoryIndex].items.splice(itemIndex, 1);
			}
			return cat;
		});
		displayedCategories = spliced;
	}

	onMount(() => {
		parse();
	});

</script>

<section>
	<div class="flex justify-center p-4">
		<div class="flex w-auto h-20">
			<img src={url + '/logos/interpretable.png'} alt="logo" class="pr-4" />
			<img src={url + '/logos/logo_erasme_entete.png'} alt="logo" class="h-auto" />
		</div>
	</div>

	<div class="text-center text-2xl">
		Interprétable est un outil de communication utilisant des pictogrammes.<br />
		Il a été développé par le laboratoire d'innovation ouverte Erasme de la Métropole de Lyon.<br />
		Pour plus d'information visitez la page
		<a class="text-purple-600" href="https://erasme.org/interpretable" target="_blank"
			>https://erasme.org/interpretable</a
		>.<br />
	</div>

	<button
		class="print:hidden roun bg-purple-600 p-3 rounded-3xl text-white fixed bottom-5 right-5 flex items-center hover:scale-125"
		on:click={() => window.print()}
	>
		<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 512 512"
			><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
			<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
			<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
			<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
			<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
			<style>
				svg {
					fill: #ffffff;
				}
			</style><path
				d="M128 0C92.7 0 64 28.7 64 64v96h64V64H354.7L384 93.3V160h64V93.3c0-17-6.7-33.3-18.7-45.3L400 18.7C388 6.7 371.7 0 354.7 0H128zM384 352v32 64H128V384 368 352H384zm64 32h32c17.7 0 32-14.3 32-32V256c0-35.3-28.7-64-64-64H64c-35.3 0-64 28.7-64 64v96c0 17.7 14.3 32 32 32H64v64c0 35.3 28.7 64 64 64H384c35.3 0 64-28.7 64-64V384zM432 248a24 24 0 1 1 0 48 24 24 0 1 1 0-48z"
			/></svg
		>
		<p class="ml-4">Imprimer</p>
	</button>

	<div class="print:hidden">
		<h1>Categories</h1>
		{#if display}
			{#each mainCategories as category, categoryIndex}
				<div class="flex flex-col">
					<div class="flex items-center">
						<input
							type="checkbox"
							id={category.category_index}
							name={category.category_index}
							value={category.category_index}
							checked={category.checked}
							on:change={(e) =>
								(displayedCategories = mainCategories.map((cat, catIndex) => {
									if (catIndex === categoryIndex) {
										cat.checked = e.target.checked;
									}
									return cat;
								}))}
						/>
						<label for={category.category_index} class="ml-2" >{category.category_label}</label>
						<p class="text-3xl cursor-pointer text-white" on:click={() => category.toggle = !category.toggle}>
							{#if !category.toggle}
							<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 256 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M246.6 278.6c12.5-12.5 12.5-32.8 0-45.3l-128-128c-9.2-9.2-22.9-11.9-34.9-6.9s-19.8 16.6-19.8 29.6l0 256c0 12.9 7.8 24.6 19.8 29.6s25.7 2.2 34.9-6.9l128-128z"/></svg>
							{:else}
							<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 320 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M182.6 470.6c-12.5 12.5-32.8 12.5-45.3 0l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8H288c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128z"/></svg>
							{/if}
						</p>
					</div>
					<div class="{category.toggle ? '' : 'hidden'}">
						{#each category.sub_categorie_items as subCategory, subCategoryIndex}
							{#if subCategory}
								<div class="ml-4">
									<input
										type="checkbox"
										id={subCategory.category_index}
										name={subCategory.category_index}
										value={subCategory.category_index}
										checked={subCategory.checked}
										on:change={(e) =>
											(displayedCategories = mainCategories.map((cat, catIndex) => {
												if (catIndex === categoryIndex) {
													cat.sub_categorie_items[subCategoryIndex].checked = e.target.checked;
												}
												return cat;
											}))}
									/>
									<label for={subCategory.category_index} class="ml-2"
										>{subCategory.category_label}</label
									>
								</div>
							{/if}
						{/each}
					</div>
				</div>
			{/each}
		{/if}
	</div>
	<div>
		{#if display}
			{#each displayedCategories as categories, categoriesIndex}
				{#if categories.checked}
					<h1 class="text-3xl">{categories?.category_label}</h1>
					{#each categories.sub_categorie_items as category, categoryIndex}
						{#if category?.checked}
							<h1 class="text-xl">{category?.category_label}</h1>
							<ul class="flex flex-wrap justify-center">
								{#if category?.items}
									{#each category.items as item, itemIndex}
										<li
											class="w-1/3 md:w-1/5 lg:w-1/6 print:w-1/5 border border-solid border-r-4 rounded-lg m-1"
										>
											<button
												class="print:hidden absolute -m-2 hover:scale-125"
												on:click={() => removeItem(categoriesIndex, categoryIndex, itemIndex)}
											>
												<svg xmlns="http://www.w3.org/2000/svg" height="2em" viewBox="0 0 512 512"
													><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
													<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
													<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
													<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
													<!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
													<style>
														svg {
															fill: #ff0000;
														}
													</style><path
														d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c9.4-9.4 24.6-9.4 33.9 0l47 47 47-47c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-47 47 47 47c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-47-47-47 47c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l47-47-47-47c-9.4-9.4-9.4-24.6 0-33.9z"
													/></svg
												>
											</button>
											<img
												src={url + '/svg/' + item.pictogram_file + '.svg'}
												alt={item.pictogram_label}
											/>
											<p>{item.pictogram_label}</p>
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
