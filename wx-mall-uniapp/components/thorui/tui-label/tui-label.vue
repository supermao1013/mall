<template>
	<view class="tui-label__box" :style="{padding:padding,margin:margin}" @tap.stop="onClick">
		<slot></slot>
	</view>
</template>

<script>
	//该组件主要用于tui-radio，tui-checkbox，tui-switch组件外层，类似label功能
	export default {
		name: "tui-label",
		props: {
			padding: {
				type: String,
				default: '0'
			},
			margin: {
				type: String,
				default: '0'
			}
		},
		created() {
			this.childrens = [];
		},
		methods: {
			onClick() {
				if (this.childrens && this.childrens.length > 0) {
					for (let child of this.childrens) {
						child.labelClick()
					}
				}
			}
		}
	}
</script>

<style scoped></style>
