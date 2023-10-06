<script lang="ts">
    //const csv=require('csvtojson')
    import type { Category, Item } from '$lib/models/index';
	import { onMount } from 'svelte';

    async function parse(): Promise<Category[]> {
        // open file
        let file = await fetch("/category.csv")
        let text = await file.text()
        let lines = text.split('\n')
        let categories: Category[] = []
        let items: Item[] = []
        let checked = []
        //remove first line
        lines.shift()
        for (let line of lines) {
            let [category_label, category_index] = line.split(',')
            let category: Category = {
                category_label: category_label,
                category_index: category_index.split('\r')[0],
                items: []
            }
            categories.push(category)
        }
        // open file
        file = await fetch("/items.csv")
        text = await file.text()
        lines = text.split('\n')
        for (let line of lines) {
            let [pictogram_label,pictogram_file,pictogram_category,pictogram_metadata] = line.split(',')
            let item: Item = {
                pictogram_label: pictogram_label,
                pictogram_file: pictogram_file,
                pictogram_category: pictogram_category
            }
            items.push(item)
        }

        for (let category of categories) {
            for (let item of items) {
                if (item.pictogram_category == category.category_index) {
                    category.items.push(item)
                }
            }
        }

        return categories
            

    }
    
    let categories: Category[] = []
    let displayedCategories: Category[] = []

    onMount( async () => {
        console.log(await parse())
        categories = await parse()
        displayedCategories = categories
    })

    async function filterCategories(category: string, value: Event) {
        console.log(category, value)
        // filter categories based on checked boxes
        let checked = value.target.checked
        console.log(checked)
        let filtered = categories
        if (checked) {
            filtered = categories.filter((cat) => cat.category_index == category)
        } else {
            filtered = categories.filter((cat) => cat.category_index != category)
        }

        
        displayedCategories = filtered
        
    }


</script>
<section>

    <div>
        <h1>Categories</h1>
        <ul class="flex flex-wrap">
            {#each categories as category}
                <li>
                    <input type="checkbox" name={category.category_index} checked on:click={(e) => filterCategories(category.category_index, e)} />
                    <label for={category.category_index}>{category.category_label}</label>
                </li>
            {/each}
        </ul>
    </div>

    {#if displayedCategories.length > 0}
        {#each displayedCategories as category}
            <h1 class="text-2xl">{category.category_label}</h1>
            <ul class="flex flex-wrap">
                {#each category.items as item}
                    <li class="w-1/5 border border-solid border-r-4 rounded-lg m-1">
                        <img src={"/svg/"+item.pictogram_file+".svg"} alt={item.pictogram_label} />
                        <p>{item.pictogram_label}</p>
                    </li>
                {/each}
            </ul>
        {/each}
    {/if}
</section>