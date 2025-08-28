import {BaseEntity, Column, Entity, OneToMany, PrimaryGeneratedColumn,} from 'typeorm';
import {Shop} from './shop.schema';


@Entity('tbl_shop_type')
export class ShopType extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @OneToMany(() => Shop, (shop) => shop.shopType)
    shops: Shop[];
}
