export default interface IMenu {
    id: string;
    name: string;
    epage_id?: string;
    icon?: string;
    url?: string;
    items: IMenu[];
}
 