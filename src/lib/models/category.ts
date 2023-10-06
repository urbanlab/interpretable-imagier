import { Item } from './item';

export interface Category {
    category_label: string;
    category_index: string;
    items: Item[];
}