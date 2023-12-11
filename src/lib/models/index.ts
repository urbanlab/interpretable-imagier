
export interface csvCategory {
    category_label: string;
    category_index: string;
}

export interface csvItem {
    pictogram_label: string;
    pictogram_file: string;
    pictogram_category: string;
    pictogram_metadata: string;
}

export interface Category {
    category_label: string;
    category_index: string;
    checked: boolean;
    toggle: boolean;
    sub_categorie_items:SubCategory[];
}

export interface SubCategory {
    category_index: string;
    category_label: string;
    checked: boolean;
    items: Item[];
}



export interface Item {
    pictogram_label: string;
    pictogram_file: string;
}