import {BaseEntity, Column, Entity, PrimaryGeneratedColumn} from 'typeorm';

@Entity('tbl_payment_type')
export class PaymentType extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ unique: true })
    type: string;

    @Column({ nullable: true })
    description: string;
}
