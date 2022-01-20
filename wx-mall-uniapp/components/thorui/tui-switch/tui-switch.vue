<template>
	<view class="tui-switch__input" :style="{zoom:scaleRatio}">
		<switch v-if="type==='switch'" @change="change" :name="name" :checked="val" :disabled="disabled" :color="color">
		</switch>
		<view class="tui-checkbox__self" :class="{'tui-checkbox__disabled':disabled}"
			:style="{backgroundColor:val?color:'#fff',border:val?`1px solid ${color}`:`1px solid ${borderColor}`}"
			v-else>
			<view class="tui-check__mark" :style="{borderBottomColor:checkMarkColor,borderRightColor:checkMarkColor}"
				v-if="val"></view>
			<switch class="tui-switch__hidden" @change="change" :name="name" type="checkbox" :checked="val"
				:disabled="disabled"></switch>
		</view>
	</view>
</template>

<script>
	export default {
		name: "tui-switch",
		behaviors: ['uni://form-field-group'],
		props: {
			//开关选择器名称
			name: {
				type: String,
				default: ''
			},
			checked: {
				type: Boolean,
				default: false
			},
			disabled: {
				type: Boolean,
				default: false
			},
			//样式，有效值：switch, checkbox
			type: {
				type: String,
				default: 'switch'
			},
			//switch选中颜色
			color: {
				type: String,
				default: '#5677fc'
			},
			//边框颜色，type=checkbox时生效
			borderColor: {
				type: String,
				default: '#ccc'
			},
			//对号颜色，type=checkbox时生效
			checkMarkColor: {
				type: String,
				default: '#fff'
			},
			scaleRatio: {
				type: [Number, String],
				default: 1
			}
		},
		data() {
			return {
				val: false
			};
		},
		watch: {
			checked(val) {
				this.val = val;
			}
		},
		created() {
			this.val = this.checked;
			this.label = this.getParent();
			if (this.label) {
				this.label.childrens.push(this)
			}
		},
		methods: {
			change(e, label) {
				if (this.label && !label) return;
				this.val = e.detail.value;
				this.$emit('change', e)
			},
			labelClick() {
				if (this.disabled) return;
				let e = {
					detail: {
						value: !this.val
					}
				}
				this.change(e, true)
			},
			getParent(name = 'tui-label') {
				let parent = this.$parent;
				let parentName = parent.$options.name;
				while (parentName !== name) {
					parent = parent.$parent;
					if (!parent) return false;
					parentName = parent.$options.name;
				}
				return parent;
			}
		}
	}
</script>

<style scoped>
	.tui-switch__input {
		display: inline-block;
	}

	.tui-checkbox__self {
		font-size: 0;
		width: 40rpx;
		height: 40rpx;
		border-radius: 50%;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		box-sizing: border-box;
		overflow: hidden;
		position: relative;
		vertical-align: top;
	}

	/* #ifdef H5 || APP-PLUS */
	>>>.uni-switch-input {
		margin-right: 0 !important;
	}

	/* #endif */

	/* #ifdef MP-WEIXIN */
	.wx-switch-input {
		margin-right: 0 !important;
	}

	/* #endif */

	.tui-check__mark {
		width: 20rpx;
		height: 40rpx;
		border-bottom: 3px solid #fff;
		border-right: 3px solid #fff;
		transform: rotate(45deg) scale(0.5);
		box-sizing: border-box;
		transform-origin: 54% 48%;
	}

	.tui-switch__hidden {
		position: absolute;
		top: 0;
		left: 0;
		opacity: 0;
		width: 100%;
		height: 100%;
		z-index: 2;
		border: 0 none;
		-webkit-appearance: none;
		-moz-appearance: none;
		appearance: none
	}

	.tui-checkbox__disabled {
		opacity: 0.6;
	}
</style>
