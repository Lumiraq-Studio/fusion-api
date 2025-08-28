import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {Shop} from './shop.schema';
import {ProductVariant} from "./product-variant.schema";
import {Status} from "../utils/enums/status.enum";

@Entity('tbl_shop_price')
export class ShopProductPrice extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => ProductVariant, (variant) => variant.shopPrices, { nullable: false })
    variant: ProductVariant;

    @ManyToOne(() => Shop, (shop) => shop.productPrices, { nullable: true })
    shop: Shop;

    @Column({ type: "decimal", precision: 10, scale: 2 })
    price: number;

    @Column({ type: 'enum', enum: Status, default: Status.ACTIVE })
    status: Status;

    @Column()
    createdBy: string;

    @Column({ nullable: true })
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({ nullable: true })
    updatedAt: Date;
}
