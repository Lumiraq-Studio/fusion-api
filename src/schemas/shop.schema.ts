import {BaseEntity, Column, CreateDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {Route} from './route.schema';
import {Order} from './order.schema';
import {Status} from "../utils/enums/status.enum";
import {ShopProductPrice} from "./shop_price.schema";
import {ShopType} from "./shop-types.schema";


@Entity('tbl_shop')
export class Shop extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    shopCode: string;

    @Column({ nullable: true })
    fullName: string;

    @Column({ nullable: true })
    shortName: string;

    @Column({ nullable: true })
    address: string;

    @Column({ nullable: true })
    mobile: string;

    @Column({ nullable: true })
    city: string;

    @Column({type: 'enum', enum: Status, default: Status.ACTIVE})
    status: Status.ACTIVE;

    @ManyToOne(() => Route, (route) => route.shops)
    route: Route;

    @OneToMany(() => Order, (order) => order.shop)
    orders: Order[];

    @OneToMany(() => ShopProductPrice, (shopProductPrice) => shopProductPrice.shop)
    productPrices: ShopProductPrice[];

    @ManyToOne(() => ShopType, (shopType) => shopType.shops, { nullable: true })
    shopType: ShopType;

    @Column()
    createdBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @Column({ nullable: true })
    updatedBy: string;
}
